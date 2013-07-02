class QuestionDependencyPair < ActiveRecord::Base
  numberable

  attr_accessible :kind

  belongs_to :dependent_question, :class_name => 'Question'
  belongs_to :independent_question, :class_name => 'Question'

  ##########################
  # Access control methods #
  ##########################
end
