class FreeResponseAnswer < ActiveRecord::Base
  content
  numberable

  attr_accessible :can_be_sketched, :free_response, :credit

  belongs_to :question

  ##########################
  # Access control methods #
  ##########################
end
