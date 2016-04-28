module Api::V1
  class VocabDistractorRepresenter < VocabTermRepresenter

    include Roar::JSON

    collection :tags, inherit: true, writeable: false

    property :license, inherit: true, writeable: false

    collection :editors, inherit: true, writeable: false

    collection :authors, inherit: true, writeable: false

    collection :copyright_holders, inherit: true, writeable: false

    collection :derivations, inherit: true, writeable: false

    property :distractor_term_number,
             as: :number,
             type: Integer,
             readable: true,
             writeable: true,
             schema_info: {
               required: true
             }

    property :name, inherit: true, writeable: false

    property :definition, inherit: true, writeable: false

  end
end
