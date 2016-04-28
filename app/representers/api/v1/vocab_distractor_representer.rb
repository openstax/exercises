module Api::V1
  class VocabDistractorRepresenter < VocabTermRepresenter

    include Roar::JSON

    property :distractor_term_number,
             as: :number,
             type: Integer,
             readable: true,
             writeable: true,
             schema_info: {
               required: true
             }

  end
end
