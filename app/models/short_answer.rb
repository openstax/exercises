class ShortAnswer < ActiveRecord::Base
  attachable :exercise
  content
  sortable :question_id

  belongs_to :question, :inverse_of => :short_answers
  has_one :exercise, :through => :question

  attr_accessible :short_answer, :credit

  validates_presence_of :question
end
