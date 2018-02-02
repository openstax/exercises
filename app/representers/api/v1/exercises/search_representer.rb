module Api::V1::Exercises
  class SearchRepresenter < OpenStax::Api::V1::AbstractSearchRepresenter

    collection :items, inherit: true,
                       class: Exercise,
                       extend: Representer

  end
end
