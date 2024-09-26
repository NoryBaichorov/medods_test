Rails.application.routes.draw do
  resources :users, only: :create

  post 'sessions/new'
  post 'sessions/refresh'
end
