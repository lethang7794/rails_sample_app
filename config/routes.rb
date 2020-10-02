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

  mount Commontator::Engine => '/commontator'

  resources :users,               only: [:index, :new, :create]
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :edit, :create, :update]

  resources :microposts,          only: [:index, :create, :show, :destroy]
  resources :microposts do
    member do
      put 'upvote'            , to: 'microposts#upvote'
      put 'unvote'            , to: 'microposts#unvote'
    end
  end

  resources :relationships,       only: [:create, :destroy]

  get    ':username'          , to: 'users#show'     , as: :user
  get    ':username/edit'     , to: 'users#edit'     , as: :edit_user
  patch  ':username'          , to: 'users#update'
  put    ':username'          , to: 'users#update'
  delete ':username'          , to: 'users#destroy'
  get    ':username/media'    , to: 'users#media'    , as: :media_user
  get    ':username/following', to: 'users#following', as: :following_user
  get    ':username/followers', to: 'users#followers', as: :followers_user

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
