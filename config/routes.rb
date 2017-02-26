Rails.application.routes.draw do
  devise_for :admin_users

  root "home#index"
  namespace :admin do
    root "home#index"
  end
  resources :users,    only:     [:index]
end
