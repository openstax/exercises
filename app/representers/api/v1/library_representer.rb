module Api::V1
  class LibraryRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: false,
             readable: true

  end
end
