Rails.application.routes.draw do
  resources :category_maps do
    post :upload_with_csv, on: :collection
  end
  resources :users
  resources :statuses, only: [:index]
  resources :downloads
  resources :batch_users, only: [:index, :create, :show] do
    post :checking_with_csv, on: :collection
    post :upload_token_with_csv, on: :collection
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
