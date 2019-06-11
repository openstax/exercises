class LogicVariableValue < ApplicationRecord

  belongs_to :logic_variable

  validates :seed, presence: true, uniqueness: { scope: :logic_variable_id }
  validates :value, presence: true

end
