Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root controller: :webview, action: :home

  get :dashboard, controller: :webview, action: :index

  scope module: :static_pages do
    get :about
    get :contact
    get :copyright
    get :developers
    get :help
    get :privacy
    get :share
    get :terms
  end

  apipie

  api :v1, default: true do
    resources :exercises do
      match :search, action: :index, via: [:get, :post], on: :collection

      publishable
    end

    resources :vocab_terms do
      match :search, action: :index, via: [:get, :post], on: :collection

      publishable
    end

    resources :users, only: [:index]

    resource :user, only: [:show, :update, :destroy]

    resources :books, only: [:index, :show], param: :uuid
  end

  mount OpenStax::Accounts::Engine => :accounts
  mount FinePrint::Engine => :fine_print
  mount ActiveStorage::Engine, at: '/rails/active_storage'
  mount OpenStax::Utilities::Engine => :status

  use_doorkeeper do
    controllers applications: :'oauth/applications'
  end

  namespace :admin do
    get :/, controller: :console, action: :index

    resources :administrators, only: [:index, :create, :destroy]

    resources :exceptions, only: [:show]

    resources :licenses

    resources :users, only: [:index] do
      member do
        put :become
        patch :delete
        patch :undelete
      end
    end

    resources :delegations, except: :show do
      get :users, on: :collection
    end

    resources :publications, only: :index do
      collection do
        patch :update
        get :collaborators
      end
    end

    resources :exercises, only: [] do
      get :invalid, on: :collection
    end
  end

  namespace :dev do
    resources :users, only: [:create] do
      post :generate, on: :collection
    end
  end

  # Catch-all frontend route, excluding active_storage
  # https://github.com/rails/rails/issues/31228
  get :'*path', controller: :webview, action: :index, constraints: ->(req) do
    req.path.exclude? 'rails/active_storage'
  end
end
