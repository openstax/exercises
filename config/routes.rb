Exercises::Application.routes.draw do
  root controller: :webview, action: :home

  get :dashboard, controller: :webview, action: :index

  scope module: :static_pages do
    get :about
    get :contact
    get :copyright
    get :developers
    get :help
    get :privacy
    get :publishing
    get :share
    get :status
    get :terms
  end

  apipie

  api :v1, default: true do
    resources :exercises do
      match :search, action: :index, via: [:get, :post], on: :collection

      resource :attachments, only: [:create, :destroy]

      publishable
      # Not in V1
      #has_logic
    end

    resources :vocab_terms do
      match :search, action: :index, via: [:get, :post], on: :collection

      publishable
    end

    # Not in V1
    #resources :logics, only: [] do
    #  post 'seeds', on: :member
    #end

    #resources :lists do
    #  publishable
    #end

    resources :users, only: [:index]

    resource :user, only: [:show, :update, :destroy]
  end

  mount OpenStax::Accounts::Engine => :accounts
  mount FinePrint::Engine => :fine_print

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

    resources :a15k, only: [] do
      get :preview, on: :member
      get :format, on: :collection
    end
  end

  namespace :dev do
    resources :users, only: [:create] do
      post :generate, on: :collection
    end
  end

  get :'*path', controller: :webview, action: :index
end
