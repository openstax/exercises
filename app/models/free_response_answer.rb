class FreeResponseAnswer < ActiveRecord::Base
  content
  numberable(:question)

  attr_accessible :can_be_sketched, :free_response, :credit

  belongs_to :question

  validates_presence_of :question

  ##################
  # Access Control #
  ##################
end
