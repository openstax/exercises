class FreeResponseAnswer < ActiveRecord::Base
  attachable :exercise
  content
  sortable :question_id

  attr_accessible :can_be_sketched, :free_response, :credit

  belongs_to :question
  has_one :exercise, :through => :question

  validates_presence_of :question

  ##################
  # Access Control #
  ##################
end
