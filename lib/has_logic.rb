module HasLogic
  module ActiveRecord
    module Base
      def has_logic(*languages)
        class_exec do
          has_one :logic, as: :parent, dependent: :destroy, inverse_of: :parent
        end
      end
    end
  end

  module ActionDispatch
    module Routing
      module Mapper
        def has_logic
          resources :logics, only: [] do
            post 'seeds', on: :member
          end
        end
      end
    end
  end

  module Roar
    module Decorator
      def has_logic(options={})
        property :logic,
                 {
                   class: Logic,
                   extend: Api::V1::Exercises::LogicRepresenter,
                   writeable: true,
                   readable: true
                 }.merge(options)
      end
    end
  end
end

ActiveRecord::Base.extend HasLogic::ActiveRecord::Base
ActionDispatch::Routing::Mapper.send :include, HasLogic::ActionDispatch::Routing::Mapper
Roar::Decorator.extend HasLogic::Roar::Decorator
