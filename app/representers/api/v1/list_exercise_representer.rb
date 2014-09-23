module Api::V1
  class ListExerciseRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    property :exercise_id,
             type: Integer,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

  end
end
