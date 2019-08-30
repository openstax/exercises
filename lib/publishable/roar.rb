module Publishable
  module Roar
    module Decorator
      def publishable(options = {})
        property :uuid,
                 {
                   type: String,
                   writeable: false,
                   readable: true
                 }.merge(options)

        property :group_uuid,
                 {
                   type: String,
                   writeable: false,
                   readable: true
                 }.merge(options)

        property :number,
                 {
                   type: Integer,
                   writeable: false,
                   readable: true
                 }.merge(options)

        property :version,
                 {
                   type: Integer,
                   writeable: false,
                   readable: true
                 }.merge(options)

        property :uid,
                 {
                   type: String,
                   writeable: false,
                   readable: true
                 }.merge(options)

        property :published_at,
                 {
                   type: String,
                   writeable: false,
                   readable: true
                 }.merge(options)

        property :nickname,
                 {
                   type: String,
                   writeable: true,
                   readable: true
                 }.merge(options)

        property :license,
                 {
                   instance: ->(input:, **) do
                     License.find_by(name: input['name']) || License.new(name: input['name'])
                   end,
                   extend: Api::V1::LicenseRepresenter,
                   writeable: true,
                   readable: true,
                   setter: ->(input:, **) { self.license = input if input.persisted? }
                 }.merge(options)

        collection :authors,
                   {
                     class: Author,
                     extend: Api::V1::RoleRepresenter,
                     writeable: false,
                     readable: true
                   }.merge(options)

        collection :copyright_holders,
                   {
                     class: CopyrightHolder,
                     extend: Api::V1::RoleRepresenter,
                     writeable: false,
                     readable: true
                   }.merge(options)

        collection :delegations,
                   {
                     class: Delegation,
                     extend: Api::V1::DelegationRepresenter,
                     writeable: false,
                     readable: true
                   }.merge(options)

        collection :derivations,
                   {
                     as: :derived_from,
                     class: Publication,
                     extend: self,
                     writeable: true,
                     readable: true,
                     setter: AR_COLLECTION_SETTER
                   }.merge(options)
      end
    end
  end
end

Roar::Decorator.extend Publishable::Roar::Decorator
