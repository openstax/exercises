module Api::V1
  class LogicVariableRepresenter < Roar::Decorator

    include Roar::Representer::JSON

    collection :logic_variable_values,
               as: :values,
               class: LogicVariableValue,
               decorator: LogicVariableValueRepresenter,
               readable: false,
               writeable: true,
               parse_strategy: :sync

  end
end
