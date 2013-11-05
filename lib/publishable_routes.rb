module Publishable
  module Routes
    def publishable
      resources :attachments, only: [:new, :create, :edit, :update, :destroy], shallow: true
      resources :collaborators, only: [:index, :new, :create, :destroy], shallow: true do
        member do
          put 'toggle_author'
          put 'toggle_copyright_holder'
        end
      end
      resources :derivations, only: [:index, :new, :create, :destroy], shallow: true

      post 'new_version', to: 'publishables#new_version'
      post 'derive', to: 'publishables#derive'
    end
  end
end

ActionDispatch::Routing::Mapper.send :include, Publishable::Routes
