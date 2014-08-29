class Solution < ActiveRecord::Base

  acts_as_votable
  publishable
  has_attachments
  has_collaborators
  has_logic :javascript, :latex

  belongs_to :question, inverse_of: :solutions

  validates :question, presence: true

end
