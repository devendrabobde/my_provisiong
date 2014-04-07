OneStop::Application.routes.draw do
  match "monitor" => "monitor#monitor", as: :monitor
  
  devise_for :caos do
    match  "back_button_destroy" => "devise/sessions#back_button_destroy"
  end
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
    get '/download_sample_file/:id', to: 'providers#download_sample_file', as: :download_sample_file
  end

  devise_scope :cao do
    root to: "devise/sessions#new"
  end
  mount Resque::Server, :at => "/resque"

  namespace :api do
    namespace :v1 do
      get "versions/check_version", to: "versions#check_version"
    end
  end

    match '/*id', :to => 'high_voltage/pages#show', :as => :static_page, :via => :get, :format => false
end
