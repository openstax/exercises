module Api::V1
  class PartRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             writeable: false

    property :position, 
              writeable: false

    property :credit

    property :background, 
             class: Content, 
             decorator: ContentRepresenter, 
             parse_strategy: :sync

    collection :questions, 
               # class: Question, 
               # decorator: QuestionRepresenter, 
               #class: lambda { |hsh, *| Api::V1::QuestionRepresenter.sub_model_for(hsh) },
               #decorator: lambda { |question, *| Api::V1::QuestionRepresenter.sub_representer_for(question) },
               parse_strategy: :sync,
               schema_info: {
                 minItems: 0
               }

  end
end

