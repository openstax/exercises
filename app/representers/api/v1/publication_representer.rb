module Api::V1
  class PublicationRepresenter < Roar::Decorator

    include Roar::JSON

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

    property :published_at,
             type: String,
             writeable: false,
             readable: true

    property :license,
             class: License,
             decorator: LicenseRepresenter,
             writeable: true,
             readable: true,
             setter: lambda { |val, args|
               self.license = License.find_by(name: val[:name])
             }

    collection :editors,
               class: Editor,
               decorator: RoleRepresenter,
               writeable: true,
               readable: true

    collection :authors,
               class: Author,
               decorator: RoleRepresenter,
               writeable: true,
               readable: true

    collection :copyright_holders,
               class: CopyrightHolder,
               decorator: RoleRepresenter,
               writeable: true,
               readable: true

    collection :derivations,
               as: :derived_from,
               class: Publication,
               decorator: PublicationRepresenter,
               writeable: true,
               readable: true

  end
end
