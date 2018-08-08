module Api::V1
  class FavoriteRepresenter < Roar::Decorator

    include Roar::JSON

    property :id,
             type: Integer,
             readable: true,
             writeable: false

    property :publication,
             type: Integer,
             readable: true,
             writeable: false

    property :user,
             type: Integer,
             readable: true,
             writeable: false
  end
end