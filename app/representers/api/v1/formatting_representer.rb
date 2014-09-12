module Api::V1
  class FormattingRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :name,
             type: String,
             writeable: true,
             readable: true,
             exec_context: :decorator,
             schema_info: {
               description: "The associated format's name"
             }

    def name
      represented.format.name
    end

    def name=(name)
      represented.format = Format.find_by(name: name)
    end

  end
end
