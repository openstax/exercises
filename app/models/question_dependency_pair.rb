class QuestionDependencyPair < ActiveRecord::Base
  sortable :dependent_question_id

  belongs_to :dependent_question, :class_name => 'Question', :inverse_of => :independent_question_pairs
  belongs_to :independent_question, :class_name => 'Question', :inverse_of => :dependent_question_pairs

  attr_accessible :independent_question, :kind

  validates_presence_of :dependent_question, :independent_question
  validates_uniqueness_of :kind, :scope => [:dependent_question_id, :independent_question_id]

  validate :valid_kind, :different_questions, :same_exercise

  scope :requirement, where(:kind => 0)
  scope :support, where(:kind => 1)

  def is_requirement?
    kind == 0
  end

  def is_support?
    kind == 1
  end

  protected

  ###############
  # Validations #
  ###############
  
  def valid_kind
    return if is_requirement? || is_support?
    errors.add(:base, "This dependency pair must either be a requirement or a support.")
    false
  end

  def different_questions
    return if dependent_question.id != independent_question.id
    errors.add(:base, "A dependency must be created between 2 different questions.")
    false
  end

  def same_exercise
    return if dependent_question.exercise == independent_question.exercise
    errors.add(:base, "Both questions in this pair must be part of the same exercise.")
    false
  end
end
