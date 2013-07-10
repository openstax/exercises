class MultipleChoiceAnswer < ActiveRecord::Base
  attachable :exercise
  content
  sortable :question_id

  attr_accessible :credit

  belongs_to :question
  has_one :exercise, :through => :question

  validates_presence_of :question

  ##################
  # Access Control #
  ##################
end
