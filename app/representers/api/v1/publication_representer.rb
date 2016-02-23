module Api::V1
  class PublicationRepresenter < Roar::Decorator

    include Roar::JSON

    publishable

  end
end
