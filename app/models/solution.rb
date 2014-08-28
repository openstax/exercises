class Solution < ActiveRecord::Base

  publishable
  logicable

  belongs_to :question, inverse_of: :solutions
  has_one :exercise, through: :question

  validates :question, presence: true

end
