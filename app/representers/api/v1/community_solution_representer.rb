module Api::V1
  class CommunitySolutionRepresenter < Roar::Decorator

    include Roar::JSON

    publishable
    solution

  end
end
