Rails.application.routes.draw do
  resources :articles
  resources :posts
  devise_for :users
  get 'home/index'
  resources :lists
  #root "articles#index"
  #root "lists#index"
  root "home#index"
end
