Exercises::Application.routes.draw do

  use_doorkeeper

  devise_for :users

  apipie

  use_doorkeeper

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1) do
      get 'dummy', :to => 'dummy#index'
    end
  end
  
  resources :api_keys, :except => [:new, :edit, :update]

  root :to => "static_page#home"

  match 'copyright', :to => 'static_page#copyright'
  match 'api', :to => 'static_page#api'
end
