Rails.application.routes.draw do
  get 'orders/create'
  get 'orders/show'
  get 'carts/create'
  devise_for :users
  resources :posts
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :packs, only: [:index, :show]
  resources :carts, only: [:create, :index, :destroy]
  resources :orders, only: [:create, :show]
  get 'home/index'
  get "mypage" => "home#mypage"
  
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
