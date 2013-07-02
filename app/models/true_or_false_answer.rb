class TrueOrFalseAnswer < ActiveRecord::Base
  content
  numberable

  attr_accessible :is_true, :credit

  belongs_to :question

  ##########################
  # Access control methods #
  ##########################
end
