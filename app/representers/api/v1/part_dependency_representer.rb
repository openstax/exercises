module Api::V1
  class PartDependencyRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :parent_part_id,
             type: Integer,
             writeable: true,
             readable: true,
             setter: lambda { |val|
               self.parent_part = dependent_part.exercise.parts.select{ |i|
                 (i.id || i.temp_id) == val
               }.first
             }

    property :is_optional,
             writeable: true,
             readable: true,
             schema_info: {
               required: true,
               type: 'boolean'
             }

  end
end
