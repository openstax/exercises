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
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

  end
end
