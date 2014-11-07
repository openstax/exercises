class ComboChoiceAnswer < ActiveRecord::Base

  belongs_to :combo_choice
  belongs_to :answer

  validates :combo_choice, presence: true
  validates :answer, presence: true, uniqueness: { scope: :combo_choice_id }
  validate :same_question

  delegate_access_control_to :combo_choice

  protected

  def same_question
    return if answer.answerable_type == 'Question' &&\
              combo_choice.question_id == answer.answerable_id
    errors.add(:base, 'the combo_choice and answer must belong to the same question')
    false
  end

end
