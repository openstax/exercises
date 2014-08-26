class ComboChoiceAnswer < ActiveRecord::Base

  belongs_to :combo_choice, inverse_of: :combo_choice_answers
  belongs_to :answer, inverse_of: :combo_choice_answers

  validates :combo_choice, presence: true
  validates :answer, presence: true, uniqueness: { scope: :combo_choice_id }
  validate :same_question

  protected

  def same_question
    return if combo_choice.question == answer.question
    errors.add(:base, 'the combo_choice and answer must belong to the same question')
    false
  end

end
