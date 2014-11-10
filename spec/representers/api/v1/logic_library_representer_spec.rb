module Api::V1
  class LogicLibraryRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :library_id,
             type: Integer,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

  end
end
