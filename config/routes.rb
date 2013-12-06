Exercises::Application.routes.draw do

  mount OpenStax::Connect::Engine, at: "/connect"
  mount FinePrint::Engine => "/admin/fine_print"

  apipie

  use_doorkeeper


  namespace 'dev' do
    get "/", to: 'base#index'

    namespace 'users' do
      post 'search'
      post 'create'
      post 'generate'
    end
  end

  resources :user_profiles, only: [:show, :edit, :update]
  
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
      post 'search', on: :collection
    end

    resources :licenses
    resources :user_groups, :only => [:index]
  end

  get "terms", to: "terms#index"
  get "terms/:id/show", to: "terms#show", as: "show_terms"
  get "terms/pose", to: "terms#pose", as: "pose_terms"
  post "terms/agree", to: "terms#agree", as: "agree_to_terms"

  resources :users, :only => [] do
    post 'become', on: :member
  end

  get "users/registration" 
  put "users/register"


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

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1) do
      resources :exercises, only: [:show, :update]
      resources :parts, only: [:show, :update, :create]
    end
  end
end
