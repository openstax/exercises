class FreeResponseAnswer < ActiveRecord::Base
  attachable :exercise
  content [:content, :free_response]
  sortable :question_id

  belongs_to :question, :inverse_of => :free_response_answers
  has_one :exercise, :through => :question

  attr_accessible :can_be_sketched, :credit

  validates_presence_of :question
end
