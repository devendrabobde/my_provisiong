require "rvm/capistrano"
require "bundler/capistrano"
require "capistrano/ext/multistage"

#Name of application
set :application, "onestop"

#Location of repository
set :repository,  "git@github01.drfirst.com:drfirst/onestop.git"

#Repository type
set :scm, :git

#Branch to use for pushing code
#set :branch, "master"
set :branch, "blackbox_testing"

#Detect rubyversion@gemset gemset used for deployment
set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")

#Only fetch the changes since the last deploy
set :deploy_via, :remote_cache

#Use local keys instead of those on the server
ssh_options[:forward_agent] = true

#ssh username
set :user, "papa"

#ssh/sudo password
set :password, "daddyo123"

#Set up environments
set :stages, ["staging", "production"]
set :default_stage, "staging"

#Compile assets in production
load 'deploy/assets'

#Use this to avoid "no tty present and no askpass program specified" error
default_run_options[:pty] = true

#Only keep the last five latest releases, otherwise the server gets too full of old releases. Works with bundle exec cap deploy:cleanup
set :keep_releases, 5

#Run tasks for rvm installation on server
before 'deploy:setup', 'rvm:install_rvm'   # install RVM
before 'deploy:setup', 'rvm:install_ruby'  # install Ruby and create gemset

#Clean up old releases on each deploy
after "deploy:move_to_tomcat", "deploy:cleanup"

#Order in which tasks are executed
after "deploy", "deploy:bundle_gems"
after "deploy:bundle_gems", "deploy:create_war_file"
after "deploy:rollback", "deploy:create_war_file"
after "deploy:create_war_file", "deploy:move_to_tomcat"

#Run bundle. Deploy the OneStop app to Tomcat.
namespace :deploy do
  task :bundle_gems do
    run "cd #{deploy_to}/current && bundle install"
  end
  task :create_war_file do
    run "cd #{deploy_to}/current && jruby -S bundle exec warble"
  end
  task :move_to_tomcat do
    #Tomcat will deploy this webapp if autoDeploy is set to 'true' and if 'unpackWARs' is set to true in server.xml
    run "#{sudo} mv #{deploy_to}/current/#{application}.war #{path_to_tomcat_app_base}"
  end
end
