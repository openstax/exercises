module Api::V1
  class PartRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :id, 
             type: Integer,
             writeable: true,
             readable: true,
             setter: lambda { |val| self.temp_id = val }

    property :background,
             type: String,
             writeable: true,
             readable: true

    collection :questions,
               class: Question,
               decorator: QuestionRepresenter,
               writeable: true,
               readable: true,
               parse_strategy: :sync,
               schema_info: {
                 required: true
               }

    collection :parent_dependencies,
               as: :dependencies,
               class: PartDependency,
               decorator: PartDependencyRepresenter,
               writeable: true,
               readable: true,
               parse_strategy: :sync,
               schema_info: {
                 required: true
               }

  end
end
