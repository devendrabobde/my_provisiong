SuperNpiOis::Application.routes.draw do

 namespace :api do
    namespace :v1 do
      namespace :ois do
        resource :supernpis do
          get 'view-user', :to =>"supernpis#view_user", :as => 'view_user'
          get 'view-provider', to: "supernpis#view_provider", as: 'view_provider'
          post 'save-provider', to: "supernpis#save_provider", as: 'save_provider'
          get 'verify-provider', to: "supernpis#verify_provider", as: 'verify_provider'
          post 'authenticate', to: "supernpis#verify_provider", as: 'authenticate'
        end
      end
    end
  end

end