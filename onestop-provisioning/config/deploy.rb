require "bundler/capistrano"
require "rvm/capistrano"
require 'capistrano/ext/multistage'

set :stages, %w(qaonestop05)
set :default_stage, "qaonestop05"

set :user, 'root'
set :application, "onestop-provisioning"
set :bundle_gemfile, "onestop-provisioning/Gemfile"

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
set :rvm_path,          "/usr/local/rvm/"
set :rvm_bin_path,      "#{rvm_path}/bin"
set :rvm_lib_path,      "#{rvm_path}/lib"

set :rvm_ruby_string, 'ruby-1.9.3-p448'
set :rvm_type, :system

set :default_environment, {
  'PATH' => "/usr/local/rvm/gems/ruby-1.9.3-p448/bin:/usr/local/rvm/gems/ruby-1.9.3-p448@global/bin:/usr/local/src/redis-stable/src:$PATH",
  'RUBY_VERSION' => 'ruby-1.9.3-p448',
  'GEM_HOME' => "/usr/local/rvm/gems/ruby-1.9.3-p448",
  'GEM_PATH' => "/usr/local/rvm/gems/ruby-1.9.3-p448:/usr/local/rvm/gems/ruby-1.9.3-p448@global",
  'BUNDLE_PATH' => "/usr/local/rvm/gems/ruby-1.9.3-p448:/usr/local/rvm/gems/ruby-1.9.3-p448@global" # If you are using bundler.
}


set :scm, 'git'
set :repository,  "git@github01.drfirst.com:drfirst/onestop.git"
set :scm_passphrase, ""

set :git_shallow_clone, 1

#NOTE: remote_cache will be only active if, the initial deployment process is completed. 
#set :deploy_via, :remote_cache
#NOTE: set "deploy_via" "copy" for the first time deployment, so that it will clone the application to the mentioned path and once successful deployment is done change it to "remote_cache". 
set :deploy_via, :copy

set :keep_releases, 3
set :scm_verbose, true

set :migrate_target, :latest

default_run_options[:pty] = true
ssh_options[:forward_agent] = true


#Need to parse a tag while deployment
set :branch do
  default_tag = `git tag`.split("\n").last

  tag = Capistrano::CLI.ui.ask "Tag to deploy (make sure to push the tag first): [#{default_tag}] "
  tag = default_tag if tag.empty?
  tag
end

require 'capistrano/cli'
require 'base64'
require 'encryptor'

def remote_file_exists?(full_path)
  'true' == capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

namespace :db do

  task :configfile do
    # Generate key
    run "mkdir -p #{shared_path}/config"
    key=Digest::SHA256.hexdigest(Time.now.to_s)
    put Base64.encode64(key),
      "#{shared_path}/config/.dbpass"

    # Create conf file
    location = fetch(:template_dir, "config/deploy") + "/#{stage}-database.yml.erb"
    template = File.read(location)
    password=Base64.encode64(Encryptor.encrypt(Capistrano::CLI.ui.ask("Enter database password: "), :key => key))
    dbpassword="<%= Util::Encrypt.decrypt('#{password}') %>"
    header="<% require 'util/encrypt' %>"
    config = ERB.new(template)
    run "mkdir -p #{shared_path}/db"
    put config.result(binding), "#{shared_path}/db/database.yml"

    # Setup links
    #run "touch database.yml"
    run "ln -nfs #{shared_path}/db/database.yml #{release_path}/onestop-provisioning/config/database.yml"
    run "ln -nfs #{shared_path}/config/.dbpass #{release_path}/onestop-provisioning/config/.dbpass"
    sudo "chmod -R 0777 #{release_path}/onestop-provisioning/tmp"
    sudo "chmod -R 0777 #{release_path}/onestop-provisioning/log"
  end

  after "deploy:finalize_update", "db:configfile"
end

# ==============================
# Uploads
# ==============================

# namespace :uploads do

#   desc <<-EOD
#     Creates the upload folders unless they exist
#     and sets the proper upload permissions.
#   EOD
#   task :setup, :except => { :no_release => true } do
#     dirs = uploads_dirs.map { |d| File.join(shared_path, d) }
#     run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
#   end

#   desc <<-EOD
#     [internal] Creates the symlink to uploads shared folder
#     for the most recently deployed version.
#   EOD
#   task :symlink, :except => { :no_release => true } do
#     run "rm -rf #{release_path}/public/csv_files"
#     run "ln -nfs #{shared_path}/csv_files #{release_path}/public/csv_files"
#   end

#   desc <<-EOD
#     [internal] Computes uploads directory paths
#     and registers them in Capistrano environment.
#   EOD
#   task :register_dirs do
#     set :uploads_dirs,    %w(csv_files)
#     set :shared_children, fetch(:shared_children) + fetch(:uploads_dirs)
#   end

#   after       "deploy:finalize_update", "uploads:symlink"
#   on :start,  "uploads:register_dirs"

# end

after 'deploy:bundle_install', 'deploy:clean_redis'
after 'deploy:clean_redis', 'deploy:resque_work'
