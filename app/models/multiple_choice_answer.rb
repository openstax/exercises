class MultipleChoiceAnswer < ActiveRecord::Base
  content
  numberable

  attr_accessible :credit

  belongs_to :question

  ##########################
  # Access control methods #
  ##########################
end
