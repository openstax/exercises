class QuestionDependency < ActiveRecord::Base

  sortable

  belongs_to :parent_question, class_name: 'Question', inverse_of: :child_dependencies
  belongs_to :dependent_question, class_name: 'Question', inverse_of: :parent_dependencies

  validates :parent_question, presence: true
  validates :dependent_question, presence: true, uniqueness: { scope: :parent_question_id }

  validate :same_part

  delegate_access_control_to :dependent_question

  protected

  def same_part
    return if parent_question.part_id == dependent_question.part_id
    error.add(:base, 'must refer to a single part')
    false
  end

end
