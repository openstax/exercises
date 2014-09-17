module Api::V1
  class UserRepresenter < Roar::Decorator

    include Roar::Representer::JSON

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
             writeable: false

    property :last_name,
             type: String,
             readable: true,
             writeable: false

    property :full_name,
             type: String,
             readable: true,
             writeable: false

    property :title,
             type: String,
             readable: true,
             writeable: false

  end
end
