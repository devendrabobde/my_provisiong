#qaonestop05

set :domain, "10.100.10.203"
set :rails_env, "production"
set :deploy_to, "/usr/local/onestop/#{application}"

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
    # run "cp -r #{shared_path}/config/database.yml #{release_path}/onestop-provisioning/config/database.yml"
    run "cp -r #{shared_path}/config/constants.yml #{release_path}/onestop-provisioning/config/constants.yml"
    run "cp -r #{shared_path}/config/environments/production.rb #{release_path}/onestop-provisioning/config/environments/production.rb"
    run "ln -nfs #{shared_path}/log #{release_path}/onestop-provisioning/log"
    run "ln -nfs #{shared_path}/tmp #{release_path}/onestop-provisioning/tmp"

    # sudo "chmod -R 0777 #{release_path}/onestop-provisioning/tmp"
    sudo "chmod -R 0666 #{release_path}/onestop-provisioning/log"
  end

  task :restart, roles: :app, except: { no_release: true } do
    run "touch #{File.join(current_path,'onestop-provisioning','tmp','restart.txt')}"
  end

  desc 'run bundle install'
  task :bundle_install, roles: :app do
    run "cd #{current_path}/onestop-provisioning && bundle exec bundle install --deployment --path #{shared_path}/bundle"
  end

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