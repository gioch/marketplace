Rails.application.routes.draw do
  resources :orders
  devise_for :users

  resources :products do
    resources :orders
  end
  get 'seller' => 'products#seller'
  get 'sales' => 'orders#sales'
  get 'purchases' => 'orders#purchases'
  
  root 'products#index'
end
