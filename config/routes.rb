Rails.application.routes.draw do
  devise_for :users,
    only: [:omniauth_callbacks],
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :playlists, only: :index do
    resources :tracks, only: :index
  end

  delete 'logout', to: 'home#logout'
  root to: "home#show"
end
