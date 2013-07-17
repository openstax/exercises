class QuestionDependencyPair < ActiveRecord::Base
  sortable :dependent_question_id

  belongs_to :dependent_question, :class_name => 'Question', :inverse_of => :independent_question_pairs
  belongs_to :independent_question, :class_name => 'Question', :inverse_of => :dependent_question_pairs

  attr_accessible :dependent_question, :independent_question, :kind

  validates_presence_of :dependent_question, :independent_question
  validates_uniqueness_of :kind, :scope => [:dependent_question_id, :independent_question_id]

  validate :valid_kind, :same_exercise

  def is_requirement?
    kind == 0
  end

  def is_support?
    kind == 1
  end

  ##################
  # Access Control #
  ##################

  def can_be_read_by?(user)
    dependent_question.exercise.can_be_read_by?(user)
  end

  def can_be_created_by?(user)
    dependent_question.exercise.can_be_updated_by?(user)
  end

  def can_be_updated_by?(user)
    can_be_created_by?(user)
  end

  def can_be_destroyed_by?(user)
    can_be_created_by?(user)
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

  def same_exercise
    return if dependent_question.exercise == independent_question.exercise
    errors.add(:base, "Both questions in this pair must be part of the same exercise.")
    false
  end
end
