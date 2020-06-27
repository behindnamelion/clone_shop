Rails.application.routes.draw do
  devise_for :users
  resources :posts
  # resources :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :packs, only: [:index, :show]
  get 'home/index'
  
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end