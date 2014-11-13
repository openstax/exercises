module Api::V1
  class DerivationRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :source_publication_id,
             type: Integer,
             readable: true,
             writeable: true,
             schema_info: {
               required: true
             }

  end
end
