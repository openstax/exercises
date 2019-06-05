class QuestionDependency < ApplicationRecord

  belongs_to :parent_question, class_name: 'Question',
                               inverse_of: :child_dependencies
  belongs_to :dependent_question, class_name: 'Question',
                                  inverse_of: :parent_dependencies

  validates :dependent_question, uniqueness: { scope: :parent_question_id }

  validate :same_exercise

  protected

  def same_exercise
    return if parent_question.nil? || dependent_question.nil? || \
              parent_question.exercise == dependent_question.exercise
    errors.add(:dependent_question,
               'must belong to the same exercise as the parent question')
    false
  end

end
