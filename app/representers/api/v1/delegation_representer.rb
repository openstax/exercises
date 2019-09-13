module Api::V1
  class DelegationRepresenter < Roar::Decorator
    include Roar::JSON

    property :delegator_id,
             type: Integer,
             writeable: false,
             readable: true,
             schema_info: {
               required: true
             }

    property :delegate_id,
             type: Integer,
             writeable: false,
             readable: true,
             schema_info: {
               required: true
             }

    property :delegate_type,
             type: String,
             writeable: false,
             readable: true,
             schema_info: {
               required: true
             }

    property :can_assign_authorship,
             type: :boolean,
             writeable: false,
             readable: true,
             schema_info: {
               required: true
             }

    property :can_assign_copyright,
             type: :boolean,
             writeable: false,
             readable: true,
             schema_info: {
               required: true
             }

    property :can_read,
             type: :boolean,
             writeable: false,
             readable: true,
             schema_info: {
               required: true
             }

    property :can_update,
             type: :boolean,
             writeable: false,
             readable: true,
             schema_info: {
               required: true
             }
  end
end
