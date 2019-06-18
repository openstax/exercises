Exercises::Application.routes.draw do
  root 'webview#home'

  get '/dashboard', to: 'webview#index'

  scope module: 'static_pages' do
    get 'about'
    get 'contact'
    get 'copyright'
    get 'developers'
    get 'help'
    get 'privacy'
    get 'publishing'
    get 'share'
    get 'status'
    get 'terms'
  end

  apipie

  api :v1, default: true do
    resources :exercises do
      match :search, action: :index, via: [:get, :post], on: :collection

      resource :attachments, only: [:create, :destroy]

      publishable
      # Not in V1
      #has_logic

      resources :questions, only: [] do
        resources :community_solutions, shallow: true, except: [:index] do
          publishable
          #has_logic
        end
      end
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

  mount OpenStax::Accounts::Engine, at: "/accounts"
  mount FinePrint::Engine => "/fine_print"

  use_doorkeeper do
    controllers applications: 'oauth/applications'
  end

  namespace 'admin' do
    get '/', to: 'console#index'

    resources :administrators, only: [:index, :create, :destroy]

    resources :exceptions, only: [:show]

    resources :licenses

    resources :trusted_applications, only: [:index, :create, :destroy]

    resources :users, only: [:index] do
      member do
        put 'become'
        patch 'delete'
        patch 'undelete'
      end
    end

    resources :delegations, except: [:new, :show, :edit]

    resources :a15k, only: [] do
      get 'preview', on: :member
      get 'format', on: :collection
    end
  end

  namespace :dev do
    resources :users, only: [:create] do
      post 'generate', on: :collection
    end
  end

  match '*path', to: 'webview#index', via: :all
end
