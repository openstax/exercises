module Api::V1
  class ListRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    publishable

  end
end
