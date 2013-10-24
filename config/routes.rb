Exercises::Application.routes.draw do
  apipie

  use_doorkeeper

  devise_for :users, :controllers => { :registrations => "registrations" }

  def publishable
    member do
      post 'derive'
      post 'new_version'
    end

    resources :collaborators, :only => [:index, :new, :create]
    resources :derivations, :only => [:index, :new, :create]
  end

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
    publishable

    resources :solutions, :only => [:index, :new, :create]

    get 'quickview', :on => :member
  end

  resources :questions, :only => [] do
    resources :question_dependency_pairs, :only => [:new, :create]
  end

  resources :question_dependency_pairs, :only => [:destroy]

  resources :solutions, :only => [:show, :edit, :update, :destroy] do
    publishable
  end

  resources :attachments

  resources :collaborators, :only => [:destroy] do
    put 'toggle_author', :on => :member
    put 'toggle_copyright_holder', :on => :member
  end

  resources :derivations, :only => [:destroy]

  resources :publishables, :only => [] do
    collection do
      get 'publication_agreement'
      post 'publish'
    end
  end

  resources :api_keys, :except => [:new, :edit, :update]

  get 'api', :to => 'static_pages#api'
  get 'copyright', :to => 'static_pages#copyright'
  get 'developers', :to => 'static_pages#developers'

  root :to => 'static_pages#home'

  namespace :admin do
    resources :users, :except => [:new, :create] do
      member do
        post 'become'
        post 'confirm'
      end
    end

    resources :licenses

    resources :user_groups, :only => [:index]

    root :to => 'console#index'
  end

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1) do
      get 'dummy', :to => 'dummy#index'
    end
  end
end
