module Api::V1
  class RoleRepresenter < Roar::Decorator

    include Roar::JSON

    property :user_id,
             type: Integer,
             readable: true,
             writeable: true,
             schema_info: {
               required: true
             }

    property :name,
             type: String,
             readable: true,
             writeable: false,
             getter: ->(*) { user.full_name },
             schema_info: {
               required: true
             }

  end
end
