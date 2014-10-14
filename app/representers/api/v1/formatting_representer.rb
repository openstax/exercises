module Api::V1
  class FormattingRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :format,
             as: :name,
             type: String,
             writeable: true,
             readable: true,
             schema_info: {
               required: true,
               description: "The associated format"
             }

  end
end
