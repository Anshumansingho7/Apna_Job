Rails.application.routes.draw do
  devise_for :users,
  :controllers => {
    :registrations => 'my_devise/registrations',
    :sessions => 'my_devise/sessions',
    :password => 'my_devise/passwords'
  }

  namespace :my_devise do
    resource :password, only: [:edit, :update]
  end

  get '/member_detail' => "members#index"
  get "/current_user" => "coustmers#index"

  namespace :api do 
    namespace :v1 do
      resources :job_recruiters
      resources :job_seekers
      resources :jobs do
        resources :apply_jobs, only: [:create]
      end
      resources :approved_jobs, only: [:update]
      resources :rejected_jobs, only: [:update]
      resources :jobs_applications, only: [:index] do 
      end
      resources :jobs_applied, only: [:index]
      resources :posts do
        resources :comments
      end
      get "/available_jobs" => "available_jobs#index"
    end
  end
end
