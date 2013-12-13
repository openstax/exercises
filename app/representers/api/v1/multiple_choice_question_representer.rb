module Api::V1
  class MultipleChoiceQuestionRepresenter < QuestionRepresenter
    include Roar::Representer::JSON

    property :type, 
             type: String,
             # decorator_scope: true,
             getter: lambda { |*| format_type.underscore },
             setter: lambda { |value, *| format_type = value.camelize },
             schema_info: {
               required: true,
               value: "multiple_choice_question"
             }

    property :stem, 
             # decorator_scope: true,
             getter: lambda { |*| format.stem },
             setter: lambda { |value, *| format.stem = value },
             class: Content, 
             decorator: ContentRepresenter, 
             parse_strategy: :sync



  end
end

