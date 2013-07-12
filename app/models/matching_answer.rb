class MatchingAnswer < ActiveRecord::Base
  attachable :exercise
  content [:left_content, :right_content]
  sortable :question_id

  belongs_to :question
  has_one :exercise, :through => :question

  attr_accessible :credit

  validates_presence_of :question

  ##################
  # Access Control #
  ##################
end
