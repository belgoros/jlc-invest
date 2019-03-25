Rails.application.routes.draw do
  resources :admins
  root to: 'clients#index'

  resources :clients

  resources :accounts, only: [:create, :destroy, :show] do
    get 'report', on: :member
    resources :operations, only: [:new, :create, :edit, :show, :update, :destroy]
  end

  resources :sessions, only: [:new, :create, :destroy]

  match '/signup',  to: 'admins#new',       via: 'get'
  match '/signin',  to: 'sessions#new',     via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'

  get '/operations', to: 'operations#index'
end
