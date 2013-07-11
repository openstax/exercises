class TrueOrFalseAnswer < ActiveRecord::Base
  attachable :exercise
  content
  sortable :question_id

  belongs_to :question
  has_one :exercise, :through => :question

  attr_accessible :is_true, :credit

  validates_presence_of :question

  ##################
  # Access Control #
  ##################
end
