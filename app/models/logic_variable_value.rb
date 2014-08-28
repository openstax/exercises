class LogicVariableValue < ActiveRecord::Base

  belongs_to :logic_variable, inverse_of: :logic_variable_values

  validates :logic_variable, presence: true
  validates :seed, presence: true, uniqueness: { scope: :logic_variable_id }
  validates :value, presence: true

  delegate_access_control to: :logic_variable

end
