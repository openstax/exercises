module Api::V1
  class RoleRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :user_id,
             type: Integer,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

  end
end
