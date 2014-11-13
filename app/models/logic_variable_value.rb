class LogicVariableValue < ActiveRecord::Base

  belongs_to :logic_variable

  validates :logic_variable, presence: true
  validates :seed, presence: true, uniqueness: { scope: :logic_variable_id }
  validates :value, presence: true

end
