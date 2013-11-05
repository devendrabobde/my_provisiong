Onestop::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :passwords, :only => [:create]

  namespace :api, :constraints => ApiParametersConstraint do
    namespace :v1 do
      resource 'check-server', :controller => 'check_server', :as => 'check_server', :only => :show

      namespace :client do
        resource 'get-private-label', :controller => 'private_labels', :as => 'private_labels', :only => :show
        resources 'verify-identity', :controller  => 'verify_identity', :as => 'verify_identity', :only => :index
        resources 'request-idp', :controller => 'request_idp', :as => 'request_idp', :only => :index
        resource 'verify-id-token', :controller => 'verify_id_token', :as => 'verify_id_token', :only => :show
        resources 'view-user', :controller => 'view_user', :as => 'view_user', :only => :index
      end

      namespace :ois do
        resource 'save-user', :controller => 'users', :as => 'users', :only => :create
        resource 'create-id-token', :controller => 'id_tokens', :as => 'id_tokens', :only => :create
      end
    end
  end
end
