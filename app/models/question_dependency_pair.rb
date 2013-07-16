class QuestionDependencyPair < ActiveRecord::Base
  sortable :dependent_question_id

  belongs_to :dependent_question, :class_name => 'Question', :inverse_of => :independent_question_pairs
  belongs_to :independent_question, :class_name => 'Question', :inverse_of => :dependent_question_pairs

  attr_accessible :dependent_question, :independent_question, :kind

  validates_presence_of :dependent_question, :independent_question
  validates_uniqueness_of :kind, :scope => [:dependent_question_id, :independent_question_id]

  ##################
  # Access Control #
  ##################
end
