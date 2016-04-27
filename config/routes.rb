Rails.application.routes.draw do
  resources :customers
  resources :users, except: [:index]
  resources :sessions, only: [:new, :create, :destroy]
  root "root#index"
end
