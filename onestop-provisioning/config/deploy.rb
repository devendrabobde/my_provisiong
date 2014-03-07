require "bundler/capistrano"
require 'capistrano/ext/multistage'

set :stages, %w(qaonestop05 production sparkway)
set :default_stage, "qaonestop05"

set :application, "onestop-provisioning"
set :bundle_gemfile, "onestop-provisioning/Gemfile"
set :user, 'sparkway'
set :use_sudo, false

set :repository,  "git@github01.drfirst.com:drfirst/onestop.git"
set :bundle_flags, "--quiet"
set :git_shallow_clone, 1

#NOTE: remote_cache will be only active if, the initial deployment process is completed. 
#set :deploy_via, :remote_cache
#NOTE: set "deploy_via" "copy" for the first time deployment, so that it will clone the application to the mentioned path and once successful deployment is done change it to "remote_cache". 
set :deploy_via, :copy

set :keep_releases, 3

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

#create config and environments folder inside shared folder at the time of cap {{stage}} deploy:setup
after("deploy:setup", "deploy:create_config_and_environment_folder")
after("deploy:create_symlink", "deploy:copy_constants_and_production")
after("deploy:create_symlink", "deploy:bundle_install")

namespace :deploy do

  desc "create config and environments folder inside shared folder at the time of cap {{stage}} deploy:setup"
  task :create_config_and_environment_folder do
    run "mkdir #{shared_path}/config"
    run "mkdir #{shared_path}/config/environments"
  end
  
  task :restart, roles: :app, except: { no_release: true } do
    run "touch #{File.join(current_path,'onestop-provisioning','tmp','restart.txt')}"
  end

  desc 'run bundle install'
  task :bundle_install, roles: :app do
    run "cd #{current_path}/onestop-provisioning && bundle exec bundle install --deployment --path #{shared_path}/bundle"
  end


  desc "Start redis server"
  task :start_redis do
    run  "cd /usr/local/src/redis-stable"
  end

  desc "clean redis queue"
  task :clean_redis do
    run "cd #{current_path}/onestop-provisioning && redis-cli FLUSHALL"
  end

  desc "Copy if the constants.yml and production.rb file is not present from constants.yml.sample and production.rb.sample"
  task :copy_constants_and_production do
    #copy constants.yml file form constants.yml.sample if the constants.yml file does not exists.
    run "if [[ ! -f #{shared_path}/config/constants.yml ]]; then cp #{release_path}/onestop-provisioning/config/constants.yml.sample #{shared_path}/config/constants.yml; fi"
    run "ln -nfs #{shared_path}/config/constants.yml #{release_path}/onestop-provisioning/config/constants.yml"

    #copy production.rb file form production.rb.sample if the production.rb file does not exists.
    run "if [[ ! -f #{shared_path}/config/environments/production.rb ]]; then cp #{release_path}/onestop-provisioning/config/environments/production.rb.sample #{shared_path}/config/environments/production.rb; fi"
    run "ln -nfs #{shared_path}/config/environments/production.rb #{release_path}/onestop-provisioning/config/environments/production.rb"
  end

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
