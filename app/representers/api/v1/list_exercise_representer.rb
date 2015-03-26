module Api::V1
  class ListExerciseRepresenter < Roar::Decorator

    include Roar::JSON

    property :exercise_id,
             type: Integer,
             writeable: true,
             readable: true,
             schema_info: {
               required: true
             }

  end
end
