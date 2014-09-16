module Api::V1
  class PublicationRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: false,
             readable: true

    publishable

  end
end
