Exercises::Application.routes.draw do

  root 'static_pages#home'

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

  mount OpenStax::Accounts::Engine, at: "/accounts"
  mount FinePrint::Engine => "/fine_print"

  use_doorkeeper do
    controllers :applications => 'oauth/applications'
  end

  apipie

  scope module: 'apipie' do
    get 'api', action: 'index'
  end

  api :v1, :default => true do

    resources :exercises, except: [:new, :edit]

    resources :logics, only: [] do
      post 'seeds', on: :member
    end

    resources :libraries, except: [:new, :edit]

    resources :lists, except: [:new, :edit]

    resources :publications, only: [:show] do
      patch 'publish', on: :member
    end

    resources :solutions, except: [:new, :edit]

    resources :users, only: [:index]

  end
  
  namespace 'admin' do
    get '/', to: 'console#index'

    resources :administrators, only: [:index, :create, :destroy]

    resource :cron, only: [:update]

    resources :exceptions, only: [:show]

    resources :formats

    resources :languages

    resources :licenses

    resources :required_libraries, only: [:index, :create, :destroy]

    resources :trusted_applications, only: [:index, :create, :destroy]

    resources :users, only: [:index] do
      member do
        put 'become'
        patch 'delete'
        patch 'undelete'
      end
    end
  end

  namespace :dev do
    resources :users, only: [:create] do
      post 'generate', on: :collection
    end
  end

  resource :user, only: [:show, :update, :destroy]

  resources :deputizations, only: [:index, :create, :destroy], path: 'deputies'

  resources :exercises, only: [:show]

end
