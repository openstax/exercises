class ShortAnswer < ActiveRecord::Base
  content
  numberable

  attr_accessible :short_answer, :credit

  belongs_to :question

  ##########################
  # Access control methods #
  ##########################
end
