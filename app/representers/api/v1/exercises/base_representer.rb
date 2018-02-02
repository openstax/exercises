module Api::V1::Exercises
  class BaseRepresenter < Roar::Decorator

    include Roar::JSON

    SOLUTIONS =          ->(user_options:, **) { !user_options[:no_solutions]   }
    NOT_SOLUTIONS_ONLY = ->(user_options:, **) { !user_options[:solutions_only] }

  end
end
