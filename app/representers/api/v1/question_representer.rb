module Api::V1
  class QuestionRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             writeable: false

    def self.sub_representer_for(question)
      case question.format
      when MultipleChoiceQuestion 
        Api::V1::MultipleChoiceQuestionRepresenter
      end
    end

    def self.sub_model_for(hsh) 
      case hash[:type]
      when 'multiple_choice_question'
        MultipleChoiceQuestion
      end
    end
  end
end

