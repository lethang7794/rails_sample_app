Rails.application.routes.draw do
  get    '/home',    to: 'static_pages#home' # In order for will_pagenite gem to generate pagination with /home URL, get '/home' need to be before root.
  root                   'static_pages#home'

  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact#'

  get    '/signup',  to: 'users#new'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :users do
    member do
      get 'following', 'followers', 'media'
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :edit, :create, :update]
  resources :microposts,          only: [:index, :create, :destroy]
  resources :relationships,       only: [:create, :destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
