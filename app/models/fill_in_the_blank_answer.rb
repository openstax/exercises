class FillInTheBlankAnswer < ActiveRecord::Base
  attachable :exercise
  content [:pre_content, :post_content]
  sortable :question_id

  attr_accessible :blank_answer, :credit

  belongs_to :question
  has_one :exercise, :through => :question

  validates_presence_of :question

  ##################
  # Access Control #
  ##################
end
