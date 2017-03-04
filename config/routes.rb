Rails.application.routes.draw do
  root "home#index"
  namespace :admin do
    devise_for :users
    root "home#index"
    resources :users
    resources :activities
    resources :cities
    resources :provinces
    resources :countries
  end
  resources :users,    only:     [:index]
end
