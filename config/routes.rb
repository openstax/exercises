Exercises::Application.routes.draw do

  root to: 'static_pages#home'

  mount OpenStax::Accounts::Engine, at: "/accounts"
  mount FinePrint::Engine => "/terms"

  use_doorkeeper do
    controllers :applications => 'oauth/applications'
  end

  apipie

  scope module: 'apipie' do
    get 'api', to: 'apipies#index'
  end

  api :v1, :default => true do

    resources :exercises

    resources :logics, except: [:index]

    resources :libraries, only: [:show, :update, :new, :create, :destroy]

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

  resource :user, only: [:show, :edit, :update, :destroy]

  resources :deputizations

  resource :static_page, only: [], path: '', as: '' do
    get 'about'
    get 'contact'
    get 'copyright'
    get 'developers'
    get 'help'
    get 'share'
    get 'status'
    get 'tou'
  end

end
