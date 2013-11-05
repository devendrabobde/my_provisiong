#Deployment locations
server "192.168.2.200", :app, :web, :db, :primary => true

#Directory on the server to deploy to
set :deploy_to, "/home/papa/Rails_Projects/onestop"

#This is the Tomcat installation's appBase directory
set :path_to_tomcat_app_base, "/opt/ApacheTomcat/apache-tomcat-7.0.39/webapps"