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
               required: true
             }

    # By not using parse_strategy: :sync, we effectively cause a Logic's 
    # LogicOutputs to be overwritten with each update call.  Since Logic
    # has a dependent destroy relationship with LogicOutput, old LogicOutputs
    # are destroyed (which is what we want).  Little nervous not having something
    # stronger in the model itself to take care of this (like a hash on the code
    # that all outputs must have to be valid).  Such a hash wouldn't even have to
    # be part of the API -- it could just be internal to the Rails app. -- call
    # it a "Logic#version" and "LogicOutput#logic_version".  Compute the hash on 
    # Logic#before_update -- how do we attach it to the outputs tho?
    collection :logic_outputs, 
               class: LogicOutput, 
               decorator: LogicOutputRepresenter, 
               schema_info: {
                 minItems: 0,
                 required: true
               }

  end
end
