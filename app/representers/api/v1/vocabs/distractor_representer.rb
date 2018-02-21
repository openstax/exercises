module Api::V1::Vocabs
  class DistractorRepresenter < TermRepresenter

    include Roar::JSON

    collection :tags, inherit: true, writeable: false

    property :nickname, inherit: true, writeable: false

    property :license, inherit: true, writeable: false

    collection :authors, inherit: true, writeable: false

    collection :copyright_holders, inherit: true, writeable: false

    collection :derivations, inherit: true, writeable: false

    property :group_uuid, inherit: true, writeable: true, schema_info: { required: true }

    property :name, inherit: true, writeable: false

    property :definition, inherit: true, writeable: false

  end
end
