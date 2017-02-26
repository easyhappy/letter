Rails.application.routes.draw do
  devise_for :admin_users

  root "inboxes#index"
  resources :users,    only:     [:index]
end
