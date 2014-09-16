module Api::V1
  class PublicationRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    publishable

  end
end
