SampleApp::Application.routes.draw do

  get "users/new"

  #custom routes  (match route to controller#acion)
  #named roots: about_path : '/about'
  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/help',    :to => 'pages#help'
  match '/signup',  :to => 'users#new'

  #root_path
  root :to => 'pages#home'

  
end
