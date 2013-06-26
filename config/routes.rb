Exercises::Application.routes.draw do
  resources :user_profiles

  resources :user_groups

  resources :user_group_members

  resources :deputizations

  resources :exercises

  resources :questions

  resources :multiple_choice_answers

  resources :matching_answers

  resources :fill_in_the_blank_answers

  resources :true_or_false_answers

  resources :short_answers

  resources :free_response_answers

  resources :solutions

  resources :licenses

  resources :lists

  resources :list_exercises

  resources :collaborators

  resources :collaborator_requests

  resources :question_dependency_pairs

  resources :attachments

  resources :api_keys, :except => [:new, :edit, :update]

  devise_for :users, :controllers => { :registrations => "registrations" }

  use_doorkeeper

  apipie

  get 'api', :to => 'static_pages#api'
  get 'copyright', :to => 'static_pages#copyright'
  get 'developers', :to => 'static_pages#developers'

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1) do
      get 'dummy', :to => 'dummy#index'
    end
  end

  root :to => "static_pages#home"
end
