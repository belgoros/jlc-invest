JlcInvest::Application.routes.draw do
  resources :admins
  root to: 'clients#index'

  resources :clients

  resources :accounts, only: [:create, :destroy, :show] do
    get 'report', on: :member
    resources :operations, only: [:new, :create, :edit, :show, :update, :destroy]
  end

  resources :sessions, only: [:new, :create, :destroy]

  get '/signin',     to: 'sessions#new'
  delete '/signout', to: 'sessions#destroy'
  get '/operations', to: 'operations#index'
end
