Rails.application.routes.draw do
  resources :opportunities

  root to: 'opportunities#index'
end
