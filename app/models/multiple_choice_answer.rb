class MultipleChoiceAnswer < ActiveRecord::Base
  attachable :exercise
  content
  sortable :question_id

  belongs_to :question
  has_one :exercise, :through => :question

  attr_accessible :is_always_last, :credit

  validates_presence_of :question

  ##################
  # Access Control #
  ##################
end
