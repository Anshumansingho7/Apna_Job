Rails.application.routes.draw do
  devise_for :users,
  :controllers => {
    :registrations => 'my_devise/registrations',
    :sessions => 'my_devise/sessions',
    :password => 'my_devise/passwords'
  }

  namespace :my_devise, path: 'my_devise' do
    resource :passwords, only: [] do
      member do
        post 'update'
        post 'updatepassword'
      end
    end
  end

  get '/member_detail' => "members#index"
  get "/current_user" => "coustmers#index"
  delete "/delete_account" => "coustmers#destroy"

  namespace :api do 
    namespace :v1 do
      resources :job_recruiters, only: [:show, :update, :create]
      get '/search/job_recruiters', to: 'job_recruiters#searchindex'
      get '/search/job_seekers', to: 'job_seekers#searchindex'
      get '/search/jobs', to: 'jobs#searchindex'
      get '/shorting/job_recruiters', to: 'job_recruiters#shortingindex'
      get '/shorting/job_seekers', to: 'job_seekers#shortingindex'
      get '/shorting/jobs', to: 'jobs#shortingindex'
      
      resources :job_seekers
      resources :myposts, only: [:index]
      patch '/upload_image/:id', to: "posts#crete_image"
      resources :jobs do
        resources :apply_jobs, only: [:create]
      end
      resources :approved_jobs, only: [:update]
      resources :rejected_jobs, only: [:update]
      resources :jobs_applications, only: [:index] do 
      end
      resources :jobs_applied, only: [:index]
      resources :notifications, only: [:index]
      resources :posts do
        resources :comments
        resources :likes
      end
      get '/likes', to: 'likes#likeindex'
      get "/available_jobs" => "available_jobs#index"
    end
  end
end
