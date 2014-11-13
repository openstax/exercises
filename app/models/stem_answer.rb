class StemAnswer < ActiveRecord::Base

  sortable

  belongs_to :stem
  belongs_to :answer

  validates :stem, presence: true
  validates :answer, presence: true, uniqueness: { scope: :stem_id }
  validates :correctness, presence: true, numericality: true

  validate :same_question

  protected

  def same_question
    return if stem.question == answer.question
    errors.add(:answer, 'must belong to the same question as the stem')
    false
  end

end
