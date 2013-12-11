module Api::V1
  class MultipleChoiceQuestionRepresenter < QuestionRepresenter
    include Roar::Representer::JSON
    # include Api::V1::QuestionRepresenter

    property :type, 
             type: String,
             schema_info: {
               required: true,
               value: "multiple_choice"
             }


    property :stem, 
             class: Content, 
             decorator: ContentRepresenter, 
             parse_strategy: :sync

  end
end

