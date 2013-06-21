Exercises::Application.routes.draw do

  resources :free_responses


  resources :short_answers


  resources :true_or_false_answers


  resources :fill_in_the_blank_answers


  resources :matching_answers


  resources :multiple_choice_answers


  resources :questions


  resources :exercises


  use_doorkeeper

  devise_for :users

  apipie

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1) do
      get 'dummy', :to => 'dummy#index'
    end
  end
  
  resources :api_keys, :except => [:new, :edit, :update]

  root :to => "static_page#home"

  match 'copyright', :to => 'static_page#copyright'
  match 'api', :to => 'static_page#api'
  match 'developers', :to => 'static_page#developers'
end
