Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root "start_pages#home"
  get "/about",     to:'start_pages#about'
  get "/contact",   to:'start_pages#contact'
  get "/signup",    to:"users#new"
  post "/signup",   to:"users#create"
  get "/login",     to:"sessions#new"
  post "/login",    to:"sessions#create"
  delete "/logout",  to:"sessions#destroy"

  resources :users
  resources :sessions ,only:[:new,:create,:destroy]
  resources :account_activations ,only:[:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
