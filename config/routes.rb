SumTimes::Application.routes.draw do
  resources :holidays, :only => [:index]

  resources :workdays, :except => [:show] do
    collection do
      get 'show', as: 'show'
      get 'on_date/:date', action: 'on_date', as: 'on_date'
    end
  end

  resources :lates
  resources :leaves, :except => [:show]
  resources :employees
  
  post 'punch_in' => 'punch_clock#in'
  post 'punch_out' => 'punch_clock#out'

  resources :schedules, :only => [:index, :create, :update, :destroy]
  resources :timesheets, :only => [:index, :show]
  resource :company, only: [:show, :edit, :update]

  devise_for :admins
  devise_for :users, :controllers => {:registrations => "users/registrations"}

  root :to => "workdays#index"
end
