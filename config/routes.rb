Rails.application.routes.draw do
  resources :users
  resources :statuses, only: [:index]
  resources :batch_users, only: [:create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
