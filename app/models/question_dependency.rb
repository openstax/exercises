class QuestionDependency < ActiveRecord::Base

  sortable

  belongs_to :parent_question, class_name: 'Question'
  belongs_to :dependent_question, class_name: 'Question'

  validates :parent_question, presence: true
  validates :dependent_question, presence: true,
                                 uniqueness: { scope: :parent_question_id }

  validate :same_exercise

  delegate_access_control_to :dependent_question

  protected

  def same_exercise
    return if parent_question.exercise_id == dependent_question.exercise_id
    error.add(:dependent_question,
              'must belong to the same exercise as the parent question')
    false
  end

end
