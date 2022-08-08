Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "homes#top"
  get "home/about", to: "homes#about", as: "about"
  devise_for :users

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create,:destroy]
    resources :book_comments, only: [:create,:destroy, :edit, :update]
  end
  
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get "followings", to: "relationships#followings", as: "followings"
    get "followers", to: "relationships#followers", as: "followers"
  end
  get "search", to: "searches#search", as: "search"

  resources :conversations, only: [:index] do
    resource :messages, only: [:show, :create]
  end
  post "conversations/:sender_id/:recipient_id/create", to: "conversations#create", as: "conversation"
end