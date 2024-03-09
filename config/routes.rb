Rails.application.routes.draw do
  get 'games/index'
  root to: 'games#index'
end
