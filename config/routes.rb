Rails.application.routes.draw do
  get 'games/index'
  get 'games/term_of_service'
  get 'games/privacy_policy'
  post 'games/create', to: 'games#create'
  root to: 'games#index'
  resources :images, only: [:index, :destroy]
end
