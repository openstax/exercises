module Api::V1::Exercises
  class LogicVariableRepresenter < BaseRepresenter

    collection :logic_variable_values,
               as: :values,
               class: LogicVariableValue,
               extend: LogicVariableValueRepresenter,
               readable: true,
               writeable: true,
               setter: AR_COLLECTION_SETTER

  end
end
