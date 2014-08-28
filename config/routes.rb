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
    get '/', to: 'base#index'

    put "cron",                         to: 'base#cron'
    get "raise_security_transgression", to: 'base#raise_security_transgression'
    get "raise_record_not_found",       to: 'base#raise_record_not_found'
    get "raise_routing_error",          to: 'base#raise_routing_error'
    get "raise_unknown_controller",     to: 'base#raise_unknown_controller'
    get "raise_unknown_action",         to: 'base#raise_unknown_action'
    get "raise_missing_template",       to: 'base#raise_missing_template'
    get "raise_not_yet_implemented",    to: 'base#raise_not_yet_implemented'
    get "raise_illegal_argument",       to: 'base#raise_illegal_argument'

    resources :users, only: [:index, :show, :update, :edit] do
      post 'become', on: :member
      post 'index', on: :collection
    end

    resources :licenses
  end

  namespace :dev do
    resources :users, only: [:create] do
      post 'generate', on: :collection
    end
  end

  resource :static_page, only: [], path: '', as: '' do
    get 'api'
    get 'copyright'
    get 'status'
    get 'developers'
  end

end
