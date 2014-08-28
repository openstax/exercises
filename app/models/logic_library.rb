class LogicLibrary < ActiveRecord::Base

  belongs_to :logic, inverse_of: :logic_libraries
  belongs_to :library, inverse_of: :logic_libraries

  validates :logic, presence: true
  validates :library, presence: true, uniqueness: { scope: :logic_id }

end
