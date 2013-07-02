class QuestionDependencyPair < ActiveRecord::Base
  numberable

  attr_accessible :dependent_question, :independent_question, :kind

  belongs_to :dependent_question, :class_name => 'Question'
  belongs_to :independent_question, :class_name => 'Question'

  validates_presence_of :dependent_question, :independent_question
  validates_uniqueness_of :kind, :scope => [:dependent_question_id, :independent_question_id]

  ##################
  # Access Control #
  ##################
end
