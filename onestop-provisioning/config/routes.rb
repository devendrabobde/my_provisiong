OneStop::Application.routes.draw do
  match "monitor" => "monitor#monitor", as: :monitor
  
  devise_for :caos
  resources :providers
  resources :home
  namespace :admin do
    resources :organizations do
      member do
        post 'activate'
        get 'show_uploaded_file'
        get 'show_provider'
        get 'download_provider'
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
  root :to => 'admin/providers#application'
  mount Resque::Server, :at => "/resque"

  namespace :api do
    namespace :v1 do
      get "versions/check_version", to: "versions#check_version"
    end
  end
end
