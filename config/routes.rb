Rails.application.routes.draw do
  get 'games/index'
  get 'games/term_of_service'
  post 'games/create', to: 'games#create'
  root to: 'games#index'
end
