Kanjime::Application.routes.draw do
  resources :users

  root :to => 'visitors#new'
end
