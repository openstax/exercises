module Api::V1::Vocabs
  class TermSearchRepresenter < OpenStax::Api::V1::AbstractSearchRepresenter

    collection :items, inherit: true,
                       class: VocabTerm,
                       extend: TermRepresenter

  end
end
