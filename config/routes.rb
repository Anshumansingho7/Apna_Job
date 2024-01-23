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

  namespace :api do 
    namespace :v1 do
      resources :job_recruiters
      resources :job_seekers
      resources :jobs
      resources :posts do
        resources :comments
      end
    end
  end
end
