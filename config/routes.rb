Rails.application.routes.draw do

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  get 'facebook/posts/:uid', to: 'facebook/posts#index'
  get 'facebook/posts/:uid/:id', to: 'facebook/posts#show'

  root to: 'pages#home'
end
