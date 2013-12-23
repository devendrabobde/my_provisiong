#require 'capistrano/ext/multistage'
require "bundler/capistrano"
require "rvm/capistrano"

set :user, 'sparkway' 
#set :user, 'ubuntu'
set :application, "onestop-provisioning"
set :use_sudo, true
set :bundle_gemfile, "onestop-provisioning/Gemfile"


$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
set :rvm_path,          "/usr/local/rvm/"
set :rvm_bin_path,      "#{rvm_path}/bin"
set :rvm_lib_path,      "#{rvm_path}/lib"

set :rvm_ruby_string, 'ruby-1.9.3-p448'
set :rvm_type, :system

set :default_environment, {
  'PATH' => "/usr/local/rvm/gems/ruby-1.9.3-p448/bin:/usr/local/rvm/gems/ruby-1.9.3-p448@global/bin:$PATH",
  'RUBY_VERSION' => 'ruby-1.9.3-p448',
  'GEM_HOME' => "/usr/local/rvm/gems/ruby-1.9.3-p448",
  'GEM_PATH' => "/usr/local/rvm/gems/ruby-1.9.3-p448:/usr/local/rvm/gems/ruby-1.9.3-p448@global",
  'BUNDLE_PATH' => "/usr/local/rvm/gems/ruby-1.9.3-p448:/usr/local/rvm/gems/ruby-1.9.3-p448@global" # If you are using bundler.
}


set :scm, 'git'
set :repository,  "git@github01.drfirst.com:drfirst/onestop.git"
set :scm_passphrase, ""
set :branch, "master"

set :git_shallow_clone, 1
set :deploy_via, :remote_cache
#set :deploy_via, :copy
set :keep_releases, 3
set :scm_verbose, true

set :migrate_target, :latest

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
 set :domain, "10.100.10.203"
set :rails_env, "production"
#set :deploy_to, "/home/ubuntu/apps/www/#{application}"
set :deploy_to, "/home/sparkway/apps/www/#{application}"
#set :deploy_to, "/var/www/#{application}"

# roles (servers)
role :web, domain
role :app, domain
role :db,  domain, :primary => true

after "deploy:restart", "deploy:cleanup"
after "deploy:create_symlink", "deploy:bundle_install"

namespace :deploy do

  desc "Copy config files"
  after "deploy:update_code" do
    run "export RAILS_ENV=production"
  # run "mkdir #{release_path}/config"
    run "cp -r #{shared_path}/config/database.yml #{release_path}/onestop-provisioning/config/database.yml"
    run "cp -r #{shared_path}/config/constants.yml #{release_path}/onestop-provisioning/config/constants.yml"
  # run "mkdir #{release_path}/config/environments"
    run "cp -r #{shared_path}/config/environments/production.rb #{release_path}/onestop-provisioning/config/environments/production.rb"
  # run "mkdir -p #{release_path}/public/images/ProfilePics"

#    sudo "chmod -R 0777 #{release_path}/onestop-provisioning/tmp/"
#    sudo "chmod -R 666 #{release_path}/onestop-provisioning/log/"
  end

  task :restart, roles: :app, except: { no_release: true } do
  #  run "touch #{File.join(current_path,'onestop-provisioning','tmp','restart.txt')}"
  end

  desc 'run bundle install'
  task :bundle_install, roles: :app do
    run "cd #{current_path}/onestop-provisioning && bundle exec bundle install --deployment --path #{shared_path}/bundle"
  end

  # desc "Reset the database"
  # task :reset do
  #   # on_rollback { deploy.db.restore }
  #   run "cd #{current_path}; bundle exec rake db:reset RAILS_ENV=production"
  # end

  desc "Import seed data in the database"
  task :seed do
    run "cd #{current_path}/onestop-provisioning && bundle exec rake db:seed RAILS_ENV=production"
  end

  task :precompile_application do
    run "cd #{current_path}/onestop-provisioning && bundle exec rake assets:precompile RAILS_ENV=production"
  end

  desc "Start redis server"
  task :start_redis do
    run  "cd /usr/local/src/redis-stable"
  end

  desc "start resque job queue"
 task :resque_work do
   run "cd #{current_path}/onestop-provisioning && RAILS_ENV=production QUEUE=providers_queue rake environment resque:work BACKGROUND=yes"
  end

  desc "clean redis queue"
  task :clean_redis do
   run "cd #{current_path}/onestop-provisioning && redis-cli FLUSHALL"
  end

end

# Below codes are out of date after bundler 1.0 released. You don't need add such codes into your cap file. Now you can add only one line in capistrano to use the bundler
# require 'bundler/capistrano'

#namespace :bundler do
#  task :create_symlink, roles: :app do
#    shared_dir = File.join(shared_path, 'bundle')
#    release_dir = File.join(current_release, '.bundle')
#    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
#  end

#  task :bundle_new_release, roles: :app do
#    bundler.create_symlink
#    run "cd #{release_path} && source $HOME/.bash_profile && bundle install"
#  end
#end

#after 'deploy:finalize_update', 'bundler:bundle_new_release'
# after 'deploy:bundle_install', 'deploy:start_solr_server'
after 'deploy:bundle_install', 'deploy:clean_redis'
#after 'deploy:clean_redis', 'deploy:resque_work'
