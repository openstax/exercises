Exercises::Application.routes.draw do

  root to: 'static_pages#home'

  mount OpenStax::Accounts::Engine, at: "/accounts"
  mount FinePrint::Engine => "/terms"

  use_doorkeeper do
    skip_controllers :applications
  end

  apipie

  api :v1, :default => true do
    
    resources :exercises, only: [:show, :update]
    resources :parts, only: [:show, :update, :create, :destroy]
    resources :questions, only: [:show, :update, :create, :destroy]

    resources :answers, only: [:show, :update, :create, :destroy]
    resources :combo_choices, only: [:show, :update, :create, :destroy]
    resources :combo_choice_answers, only: [:show, :create, :destroy]

    resources :logics, except: [:index]

    resources :libraries, only: [:show, :update, :new, :create, :destroy]

    resources :users, only: [:index] do
      collection do
        get 'registration'
        put 'register'
      end
    end

  end
  
  namespace 'admin' do
    get '/', to: 'console#index'

    resources :administrators

    resource :cron, only: [:update]

    resources :exceptions, only: [:show]

    resources :formats, only: [:index, :new, :create, :destroy]

    resources :languages

    resources :licenses

    resources :required_libraries, only: [:index, :new, :create, :destroy]

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
    get 'api'
    get 'copyright'
    get 'status'
    get 'developers'
  end

end
