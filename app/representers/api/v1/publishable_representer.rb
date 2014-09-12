module Api::V1
  class PublishableRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :uid,
             type: String,
             writeable: false,
             readable: true

    property :number,
             type: Integer,
             writeable: false,
             readable: true

    property :version,
             type: Integer,
             writeable: false,
             readable: true

    property :license,
             class: License,
             decorator: LicenseRepresenter,
             parse_strategy: :sync,
             writeable: true,
             readable: true

    collection :parts,
               class: Part,
               decorator: PartRepresenter,
               parse_strategy: :sync,
               writeable: true,
               readable: true,
               schema_info: {
                 required: true
               }

  end
end
