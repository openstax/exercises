module Publishable
  module Roar
    module Decorator
      def publishable

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
                 decorator: Api::V1::LicenseRepresenter,
                 writeable: true,
                 readable: true,
                 setter: lambda { |val, args|
                   self.license = License.find_by(name: val[:name])
                 }

        collection :editors,
                   class: Editor,
                   decorator: Api::V1::RoleRepresenter,
                   writeable: true,
                   readable: true

        collection :authors,
                   class: Author,
                   decorator: Api::V1::RoleRepresenter,
                   writeable: true,
                   readable: true

        collection :copyright_holders,
                   class: CopyrightHolder,
                   decorator: Api::V1::RoleRepresenter,
                   writeable: true,
                   readable: true

        collection :derivations,
                   as: :derived_from,
                   class: Publication,
                   decorator: self,
                   writeable: true,
                   readable: true

      end
    end
  end
end

Roar::Decorator.extend Publishable::Roar::Decorator
