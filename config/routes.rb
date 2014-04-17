Exercises::Application.routes.draw do
  mount OpenStax::Accounts::Engine, at: "/accounts"
  mount FinePrint::Engine => "/admin/fine_print"

  use_doorkeeper do
    skip_controllers :applications
  end

  apipie

  get 'api', to: 'static_pages#api'

  api :v1, :default => true do
    
    resources :exercises, only: [:show, :update]
    resources :parts, only: [:show, :update, :create, :destroy]
    resources :questions, only: [:show, :update, :create, :destroy]
    resources :simple_choices, only: [:show, :update, :create, :destroy] do
      put 'sort', on: :collection
    end
    resources :combo_choices, only: [:show, :update, :create, :destroy]
    resources :combo_simple_choices, only: [:show, :create, :destroy]
    resources :logics, except: [:index]
    resources :libraries, only: [:show, :update, :new, :create, :destroy]
    resources :library_versions, only: [:show, :update, :create, :destroy] do
      get 'digest', on: :collection
    end
    resources :users, only: [] do
      get 'search', on: :collection
    end
    
  end
  
  namespace 'admin' do
    get '/', to: 'base#index'

    put "cron",                         to: 'base#cron', :as => "cron"
    get "raise_security_transgression", to: 'base#raise_security_transgression'
    get "raise_record_not_found",       to: 'base#raise_record_not_found'
    get "raise_routing_error",          to: 'base#raise_routing_error'
    get "raise_unknown_controller",     to: 'base#raise_unknown_controller'
    get "raise_unknown_action",         to: 'base#raise_unknown_action'
    get "raise_missing_template",       to: 'base#raise_missing_template'
    get "raise_not_yet_implemented",    to: 'base#raise_not_yet_implemented'
    get "raise_illegal_argument",       to: 'base#raise_illegal_argument'

    resources :users, only: [:show, :update, :edit] do
      post 'become', on: :member
      post 'search', on: :collection
    end

    resources :licenses
    resources :user_groups, :only => [:index]

    resources :libraries do
      resources :library_versions, :shallow => true
    end

    namespace :dev do
      resources :users, only: [:create] do
        post 'generate', on: :collection
      end
    end
  end

  get "terms/:id/show", to: "terms#show", as: "show_terms"
  get "terms/pose", to: "terms#pose", as: "pose_terms"
  post "terms/agree", to: "terms#agree", as: "agree_to_terms"

  get "users/registration" 
  put "users/register"


  resources :user_groups do
    namespace :oauth do
      resources :applications, shallow: true
    end
    
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

  get 'copyright', to: 'static_pages#copyright'
  get 'developers', to: 'static_pages#developers'

  post 'sort', to: 'sortables#sort'

  root to: 'static_pages#home'
end
