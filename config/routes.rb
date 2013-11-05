Exercises::Application.routes.draw do
  apipie

  use_doorkeeper

  devise_for :users, controllers: { registrations: "registrations" }

  resources :users, only: [] do
    collection do
      get 'help'
    end
  end

  resources :user_profiles, only: [:show, :edit, :update]

  resources :user_groups do
    resources :user_group_users, only: [:new, :create, :destroy], shallow: true do
      put 'toggle', on: :member
    end
  end

  resources :lists do
    resources :list_exercises, only: [:new, :create, :destroy], shallow: true
  end

  resources :exercises do
    publishable

    resources :solutions, shallow: true

    get 'quickview', on: :member
  end

  resources :questions, only: [] do
    resources :question_dependency_pairs, only: [:new, :create, :destroy], shallow: true
  end

  resources :solutions, only: [] do
    publishable
  end

  resources :publishables, only: [] do
    collection do
      get 'publication_agreement'
      post 'publish'
    end
  end

  resources :api_keys, except: [:new, :edit, :update]

  get 'api', to: 'static_pages#api'
  get 'copyright', to: 'static_pages#copyright'
  get 'developers', to: 'static_pages#developers'

  root to: 'static_pages#home'

  namespace :admin do
    resources :users, except: [:new, :create] do
      member do
        post 'become'
        post 'confirm'
      end
    end

    resources :licenses

    resources :user_groups, only: :index

    root to: 'console#index'
  end

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1) do
      get 'dummy', to: 'dummy#index'
    end
  end
end
