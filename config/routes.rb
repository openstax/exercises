Exercises::Application.routes.draw do
  apipie

  use_doorkeeper

  devise_for :users, :controllers => { :registrations => "registrations" }

  resources :users, :only => [] do
    collection do
      get 'help'
    end
  end

  resources :user_profiles, :only => [:show, :edit, :update]

  resources :user_groups do
    resources :user_group_users, :only => [:new, :create]
  end

  resources :user_group_users, :only => [:destroy] do
    put 'toggle', :on => :member
  end

  resources :lists do
    resources :list_exercises, :only => [:new, :create]
  end

  resources :list_exercises, :only => [:destroy]

  resources :exercises do
    get 'quickview', :on => :member

    resources :collaborators, :only => [:new, :create]
  end

  resources :questions, :only => [] do
    resources :question_dependency_pairs, :only => [:new, :create, :destroy]
    resources :solutions, :only => [:new, :create]
  end

  resources :solutions, :only => [:edit, :update, :destroy] do
    resources :collaborators, :only => [:new, :create]
  end

  resources :attachments

  resources :collaborators, :only => [:destroy] do
    put 'toggle_author', :on => :member
    put 'toggle_copyright_holder', :on => :member
  end

  resources :api_keys, :except => [:new, :edit, :update]

  get 'api', :to => 'static_pages#api'
  get 'copyright', :to => 'static_pages#copyright'
  get 'developers', :to => 'static_pages#developers'

  root :to => "static_pages#home"

  namespace :admin do
    resources :users, :except => [:new, :create] do
      member do
        post 'become'
        post 'confirm'
      end
    end

    resources :licenses

    resources :user_groups, :only => [:index]
  end

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1) do
      get 'dummy', :to => 'dummy#index'
    end
  end
end
