module Api::V1
  class StylingRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :style,
             as: :name,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true,
               description: "The associated style"
             }

  end
end
