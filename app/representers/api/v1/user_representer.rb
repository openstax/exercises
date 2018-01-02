module Api::V1
  class UserRepresenter < Roar::Decorator

    include Roar::JSON

    property :id,
             type: Integer,
             readable: true,
             writeable: false

    property :username,
             type: String,
             readable: true,
             writeable: false

    property :first_name,
             type: String,
             readable: true,
             writeable: true

    property :last_name,
             type: String,
             readable: true,
             writeable: true

    property :full_name,
             type: String,
             readable: true,
             writeable: true

    property :title,
             type: String,
             readable: true,
             writeable: true

    property :faculty_status,
             type: String,
             readable: true,
             writeable: false

    property :role,
             as: :self_reported_role,
             type: String,
             readable: true,
             writeable: false

    property :uuid,
             type: String,
             readable: true,
             writeable: false

    property :support_identifier,
             type: String,
             readable: true,
             writeable: false

  end
end
