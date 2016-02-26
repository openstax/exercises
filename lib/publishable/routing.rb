module Publishable
  module ActionDispatch
    module Routing
      module Mapper
        def publishable
          put 'publish', to: 'publications#publish'
        end
      end
    end
  end
end

ActionDispatch::Routing::Mapper.send :include, Publishable::ActionDispatch::Routing::Mapper
