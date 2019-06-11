class ComboChoiceAnswer < ApplicationRecord

  belongs_to :combo_choice
  belongs_to :answer

  validates :answer, uniqueness: { scope: :combo_choice_id }
  validate :same_question

  protected

  def same_question
    return if combo_choice.nil? || combo_choice.stem.nil? || answer.nil? || \
              combo_choice.stem.question == answer.question
    errors.add(:answer, 'must belong to the same question as the combo choice')
    false
  end

end
