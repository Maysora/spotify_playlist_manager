Rails.application.routes.draw do
  devise_for :users,
    only: [:omniauth_callbacks],
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  delete 'logout', to: 'home#logout'
  root to: "home#show"
end