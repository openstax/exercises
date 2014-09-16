module Api::V1
  class PublicationRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: false,
             readable: true,
             schema_info: {
               required: true
             }

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
             writeable: true,
             readable: true,
             setter: lambda { |val|
              self.license = License.find_by(name: val[:name])
             }

    collection :derivations,
               as: :derived_from,
               class: Publication,
               decorator: PublicationRepresenter,
               writeable: true,
               readable: true

    collection :editors,
               class: Editor,
               decorator: Api::V1::CollaboratorRepresenter,
               writeable: true,
               readable: true

    collection :authors,
               class: Author,
               decorator: Api::V1::CollaboratorRepresenter,
               writeable: true,
               readable: true

    collection :copyright_holders,
               class: CopyrightHolder,
               decorator: Api::V1::CollaboratorRepresenter,
               writeable: true,
               readable: true

  end
end
