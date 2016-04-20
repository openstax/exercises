class TermTag < ActiveRecord::Base
  belongs_to :term
  belongs_to :tag

  validates :term, presence: true
  validates :tag, presence: true, uniqueness: { scope: :term_id }
end
