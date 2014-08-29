module Api::V1
  class LogicRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: false,
             schema_info: {
               required: true
             }

    property :code,
             type: String,
             writeable: true,
             schema_info: {
               required: true
             }

    property :library_ids,
             type: String,
             writeable: true,
             schema_info: {
               required: true,
               description: 
                 "JSON-stringified array of integer IDs of code libraries," +
                 "listed in the order the code should be read/included before" +
                 "the code in this Logic is read/included."
             }

    property :logic_variables,
             type: String,
             writeable: true,
             schema_info: {
               required: true,
               description: "JSON-stringified array of variable string names"
             }

    collection :logic_outputs, 
               class: LogicVariableValue, 
               decorator: LogicVariableValueRepresenter, 
               setter: (lambda do |logic_outputs_array, *| 
                          attributes_array = logic_outputs_array.collect{|lo| lo.attributes.except('id', 'created_at', 'updated_at') }
                          logic_outputs.build(attributes_array)
                        end),
               schema_info: {
                 minItems: 0,
                 required: true
               }

  end
end
