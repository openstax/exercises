module Api::V1
  class QuestionRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, 
             writeable: false

  end
end
