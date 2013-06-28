Exercises::Application.routes.draw do
  apipie

  use_doorkeeper

  devise_for :users, :controllers => { :registrations => "registrations" }

  resources :users, :only => [] do
    get 'help'
    post 'search'
  end

  resources :user_profiles

  resources :user_groups

  resources :user_group_members

  resources :exercises

  resources :questions

  resources :multiple_choice_answers

  resources :matching_answers

  resources :fill_in_the_blank_answers

  resources :true_or_false_answers

  resources :short_answers

  resources :free_response_answers

  resources :solutions

  resources :licenses do
    collection do
      put 'make_default'
    end
  end

  resources :lists

  resources :list_exercises

  resources :collaborators

  resources :collaborator_requests

  resources :question_dependency_pairs

  resources :attachments

  resources :api_keys, :except => [:new, :edit, :update]



  get 'api', :to => 'static_pages#api'
  get 'copyright', :to => 'static_pages#copyright'
  get 'developers', :to => 'static_pages#developers'

  namespace :admin do
    resources :users, :only => [:index, :show, :edit, :update] do
      post 'become'
      post 'confirm'
    end
  end

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1) do
      get 'dummy', :to => 'dummy#index'
    end
  end

  root :to => "static_pages#home"
end
