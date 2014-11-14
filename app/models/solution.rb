class Solution < ActiveRecord::Base

  acts_as_votable
  parsable :summary, :details
  publishable
  has_attachments
  has_logic :javascript, :latex
  stylable

  belongs_to :question

  validates :question, presence: true

end
