Rails migrations
================

Further Reading: http://guides.rubyonrails.org/migrations.html

Quick reference:

`bundle exec rake db:create RAILS_ENV=production` - Creates the database
for the production environment

`bundle exec rake db:migrate RAILS_ENV=production` - Create all tables
and indexes for the application. Applies all new migrations.

`bundle exec rake db:seed RAILS_ENV=production` - Load default data into
the database. WARNING: This should be run only one time.

Please refer to the reference documentation above for further details.
