module Api::V1
  class PartRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    property :id, writeable: false
    property :position, writeable: false
    property :credit
    property :background, class: Content, decorator: ContentRepresenter, parse_strategy: :sync

    # collection :questions

  end
end

