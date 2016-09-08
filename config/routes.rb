Rails.application.routes.draw do
  devise_for :users

  root "inboxes#index"

  resources :inboxes,  only:     [:index, :create, :destroy, :show]
  resources :messages, only:     [:create, :destroy]
  resources :users,    only:     [:index]
end
