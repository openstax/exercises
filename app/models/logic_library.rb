class LogicLibrary < ActiveRecord::Base

  sortable

  belongs_to :logic
  belongs_to :library

  validates :logic, presence: true
  validates :library, presence: true, uniqueness: { scope: :logic_id }

end
