class Logic < ActiveRecord::Base

  belongs_to :logicable, polymorphic: true
  belongs_to :language, inverse_of: :logics

  has_many :logic_libraries, dependent: :destroy, inverse_of: :logic
  has_many :libraries, through: :logic_libraries

  has_many :logic_variables, dependent: :destroy, inverse_of: :logic
  has_many :logic_variable_values, through: :logic_variables

  validates :logicable, presence: true, uniqueness: true
  validates :language, presence: true

  delegate_access_control_to :logicable

end
