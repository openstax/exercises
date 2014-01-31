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

    property :variables,
             type: String,
             writeable: true,
             schema_info: {
               required: true,
               description: "JSON-stringified array of variable string names"
             }

    property :library_version_ids,
             type: String,
             writeable: true,
             schema_info: {
               required: true,
               description: 
                 "JSON-stringified array of integer IDs of code libraries," +
                 "listed in the order the code should be read/included before" +
                 "the code in this Logic is read/included."
             }

    # this comment out of date: see below (TODO remove it)
    # By not using parse_strategy: :sync, we effectively cause a Logic's 
    # LogicOutputs to be overwritten with each update call.  Since Logic
    # has a dependent destroy relationship with LogicOutput, old LogicOutputs
    # are destroyed (which is what we want).  Little nervous not having something
    # stronger in the model itself to take care of this (like a hash on the code
    # that all outputs must have to be valid).  Such a hash wouldn't even have to
    # be part of the API -- it could just be internal to the Rails app. -- call
    # it a "Logic#version" and "LogicOutput#logic_version".  Compute the hash on 
    # Logic#before_update -- how do we attach it to the outputs tho?
    #
    # Note: changed the above but leaving comment for the moment.  Realized the default
    # setter in representable was the one doing the saving of the logic_outputs in the
    # collection.  Added a custom setter that uses collection.build to avoid the automatic
    # save.  Now after_update in logic we are deleting old logic_outputs.
    collection :logic_outputs, 
               class: LogicOutput, 
               decorator: LogicOutputRepresenter, 
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
