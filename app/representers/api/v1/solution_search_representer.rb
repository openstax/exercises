module Api::V1
  class SolutionSearchRepresenter < OpenStax::Api::V1::AbstractSearchRepresenter

    collection :items, inherit: true,
                       class: Solution,
                       decorator: SolutionRepresenter

  end
end
