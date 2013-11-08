Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  get 'home', to: 'videos#index'

  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end
  end
  resources :categories, only: [:show], path: 'genres'
  resources :users, only: [:create]
  resources :sessions, only: [:create]

  get 'ui(/:action)', controller: 'ui'
end
