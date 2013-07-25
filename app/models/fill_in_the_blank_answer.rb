class FillInTheBlankAnswer < ActiveRecord::Base
  attachable :exercise
  content [:pre_content, :post_content]
  sortable :question_id

  belongs_to :question, :inverse_of => :fill_in_the_blank_answers
  has_one :exercise, :through => :question

  attr_accessible :blank_answer, :credit

  validates_presence_of :question
end
