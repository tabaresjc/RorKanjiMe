Kanjime::Application.routes.draw do
  get 'pages/about'
  get 'pages/help'
  get 'pages/home'
  
  resources :users
  root :to => 'pages#home'
  match '/signup',  to: 'users#new', via: 'get'
end
