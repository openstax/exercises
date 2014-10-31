class Solution < ActiveRecord::Base

  acts_as_votable
  parsable :summary, :details
  publishable
  has_attachments
  has_logic :javascript, :latex
  sort_domain

  belongs_to :question, inverse_of: :solutions

  validates :question, presence: true

end
