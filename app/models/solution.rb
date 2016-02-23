class Solution < ActiveRecord::Base

  acts_as_votable
  parsable :content
  has_attachments
  has_logic :javascript, :latex
  stylable

  belongs_to :question

  validates :question, presence: true
  validates :solution_type, presence: true, inclusion: { in: SolutionType.all }
  validates :content, presence: true

end
