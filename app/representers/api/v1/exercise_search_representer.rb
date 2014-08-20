module Api::V1
  class ExerciseSearchRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :q,
             type: String,
             writeable: true,
             schema_info: {
               description: "The query string."
             }

    property :num_matching_exercises,
             type: Integer,
             writeable: false,
             schema_info: {
               description: "The number of exercises that match the query, can be more than the number returned"
             }

    property :page,
             type: Integer, 
             writeable: false,
             schema_info: {
               description: "The current page number of the returned results"
             }

    property :per_page,
             type: Integer,
             writeable: false,
             schema_info: {
               description: "The number of results per page"
             }

    property :order_by,
             type: String,
             writeable: false,
             schema_info: {
               description: "The ordering info, which may be different than what was requested if the request was missing defaults or had bad settings."
             }


    collection :exercises,
               class: Exercise,
               decorator: Api::V1::ExerciseRepresenter,
               schema_info: {
                 description: "The exercises matching the query or a subset thereof when paginating",
                 minItems: 0
               }

  end
end