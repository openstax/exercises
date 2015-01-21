module Api::V1
  class ListSearchRepresenter < OpenStax::Api::V1::AbstractSearchRepresenter

    collection :items, inherit: true,
                       class: List,
                       decorator: ListRepresenter

  end
end
