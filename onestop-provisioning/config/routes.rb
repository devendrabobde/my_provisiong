OneStop::Application.routes.draw do
  devise_for :caos  #, :controllers => {:registrations => "adminregistrations"}
  resources :providers
  resources :home
  namespace :admin do
    resources :organizations do
      member do
        post 'activate'
        get 'show_uploaded_file'
        get 'show_provider'
      end
      resources :caos do
        member do
          post 'activate'
        end
      end
    end
    resources :providers do
      collection do
        get 'application'
        post 'upload'
        get 'pull_redis_job_status'
      end
    end
    get '/download/:id', to: 'providers#download', as: 'download'
  end

#  namespace :api do
#    namespace :v1 do
#      namespace :ois do
#       resource :epcs do
#          post 'save-provider', to: "epcs#save_provider", as: 'save_provider'
#          post 'batch_upload_dest', to: "epcs#batch_upload_dest", as: 'batch_upload_dest'
#          get 'verify-provider', to: "epcs#verify_provider", as: 'verify_provider'
#          get 'view-provider', to: "epcs#view_provider", as: 'view_provider'
#          get 'authenticate', to: "epcs#authenticate", as: 'authenticate'
#        end
#     end
#    end
#  end
  root :to => 'admin/providers#application'
  mount Resque::Server, :at => "/resque"
end
