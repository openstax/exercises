module Api::V1
  class LogicVariableRepresenter < Roar::Decorator

    include Roar::JSON

    collection :logic_variable_values,
               as: :values,
               class: LogicVariableValue,
               extend: LogicVariableValueRepresenter,
               readable: false,
               writeable: true

  end
end
