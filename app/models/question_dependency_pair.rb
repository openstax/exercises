class QuestionDependencyPair < ActiveRecord::Base
  attr_accessible :dependent_question_id, :independent_question_id, :kind
end
