Rails.application.routes.draw do
  resources :users
  resources :statuses, only: [:index]
  resources :downloads
  resources :batch_users, only: [:index, :create, :show] do
    post :checking_with_csv, on: :collection
  end
  post '/patients/:id', to: 'patients#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
