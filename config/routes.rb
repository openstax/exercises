Exercises::Application.routes.draw do

  resources :website_configurations


  resources :exercise_derivations


  resources :question_dependency_pairs


  resources :attachable_assets


  resources :assets


  resources :announcements


  resources :free_response_answers


  resources :user_profiles


  resources :exercise_collaborator_requests


  resources :exercise_collaborators


  resources :list_exercises


  resources :lists


  resources :user_group_members


  resources :user_groups


  resources :licenses


  resources :solutions


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
