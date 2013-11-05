EpcsIdpOis::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :ois do
        resource :epcs do
          post 'save-provider', to: "epcs#save_provider", as: 'save_provider'
          post 'batch_upload_dest', to: "epcs#batch_upload_dest", as: 'batch_upload_dest'
          get 'verify-provider', to: "epcs#verify_provider", as: 'verify_provider'
          get 'view-provider', to: "epcs#view_provider", as: 'view_provider'
          get 'authenticate', to: "epcs#authenticate", as: 'authenticate'
        end
      end
    end
  end
end
