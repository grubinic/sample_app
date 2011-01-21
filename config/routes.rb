SampleApp::Application.routes.draw do
  #only some actions - options hash
  resources :sessions, :only => [:new, :create, :destroy]  
  #REST defined here - GET users/new, GET users/1, .. + named routes
  resources :users
  
  #custom routes  (match route to controller#acion)
  #named roots: about_path : '/about'
  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/help',    :to => 'pages#help'
  match '/signup',  :to => 'users#new'
  #custom - aletrnative/replacement to POST sessions ?
  match '/signin',  :to => 'sessions#new'
  #custom - aletrnative/replacemenet to DELETE sessions ?
  match '/signout', :to => 'sessions#destroy'

  #root_path
  root :to => 'pages#home'
  
end
