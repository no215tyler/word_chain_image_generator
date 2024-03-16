Rails.application.routes.draw do
  get 'games/index'
  post 'games/create', to: 'games#create'
  root to: 'games#index'
end
