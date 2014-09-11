require 'representable/json/collection'

module Api::V1
  module SolutionsRepresenter
    include Representable::JSON::Collection

    items class: Solution, decorator: SolutionRepresenter
  end
end
