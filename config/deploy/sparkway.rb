set :domain, "10.100.10.203"
set :rails_env, "production"
set :deploy_to, "/usr/local/onestop/#{application}"
set :branch, "master"

# roles (servers)
role :web, domain
role :app, domain
role :db,  domain, :primary => true

namespace :deploy do

  desc "Copy config files"
  after "deploy:update_code" do
    run "export RAILS_ENV=production"
    run "ln -nfs #{shared_path}/log #{release_path}/log"
    run "ln -nfs #{shared_path}/tmp #{release_path}/tmp"

    sudo "chmod -R 0777 #{release_path}/tmp"
    sudo "chmod -R 0777 #{release_path}/log"
  end

  desc "Import seed data in the database"
  task :seed do
    run "cd #{current_path} && bundle exec rake db:seed RAILS_ENV=production"
  end

  task :precompile_application do
    run "cd #{current_path} && bundle exec rake assets:precompile RAILS_ENV=production"
  end

  desc "start resque job queue"
  task :resque_work do
    run "cd #{current_path} && RAILS_ENV=production QUEUE=providers_queue,cached_updation rake environment resque:work BACKGROUND=yes"
  end

end
