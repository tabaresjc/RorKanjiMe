Kanjime::Application.routes.draw do
  get 'pages/about'
  get 'pages/help'
  get 'pages/home'
  
  resources :users
  root :to => 'pages#home'
  
end
