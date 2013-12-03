module Api::V1
  class ExerciseRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, writeable: false
    property :number, writeable: false
    property :version, writeable: false
    property :background, class: Content, decorator: ContentRepresenter, parse_strategy: :sync
    collection :parts, class: Part, decorator: PartRepresenter, parse_strategy: :sync

  end
end