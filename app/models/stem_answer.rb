class StemAnswer < ApplicationRecord

  belongs_to :stem
  belongs_to :answer

  validates :answer, uniqueness: { scope: :stem_id }
  validates :correctness, presence: true, numericality: { greater_than_or_equal_to: 0.0,
                                                          less_than_or_equal_to: 1.0 }

  validate :same_question

  def is_correct?
    correctness == 1.0
  end

  protected

  def same_question
    return if stem.nil? || answer.nil? || stem.question == answer.question
    errors.add(:answer, 'must belong to the same question as the stem')
    false
  end

end
