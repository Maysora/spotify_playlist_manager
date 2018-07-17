Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users,
    only: [:omniauth_callbacks],
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :playlists, only: :index do
    resources :tracks, only: :index
  end

  resources :multi_playlists, only: [:new, :create, :edit, :update, :destroy]

  delete 'logout', to: 'home#logout'
  root to: "home#show"
end
