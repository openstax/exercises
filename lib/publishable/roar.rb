module Publishable
  module Roar
    module Decorator
      def publishable

        property :uuid,
                 type: String,
                 writeable: false,
                 readable: true

        property :group_uuid,
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

        property :uid,
                 type: String,
                 writeable: false,
                 readable: true

        property :published_at,
                 type: String,
                 writeable: false,
                 readable: true

        property :license,
                 class: License,
                 extend: Api::V1::LicenseRepresenter,
                 writeable: true,
                 readable: true,
                 setter: ->(input:, **) { self.license = License.find_by(name: input[:name]) }

        collection :authors,
                   class: Author,
                   extend: Api::V1::RoleRepresenter,
                   writeable: true,
                   readable: true,
                   setter: AR_COLLECTION_SETTER

        collection :copyright_holders,
                   class: CopyrightHolder,
                   extend: Api::V1::RoleRepresenter,
                   writeable: true,
                   readable: true,
                   setter: AR_COLLECTION_SETTER

        collection :derivations,
                   as: :derived_from,
                   class: Publication,
                   extend: self,
                   writeable: true,
                   readable: true,
                   setter: AR_COLLECTION_SETTER

      end
    end
  end
end

Roar::Decorator.extend Publishable::Roar::Decorator
