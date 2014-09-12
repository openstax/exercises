module Api::V1
  class SolutionRepresenter < Roar::Decorator
    include Roar::Representer::JSON

    publishable
    has_collaborators
    has_logic
    has_attachments

  end
end
