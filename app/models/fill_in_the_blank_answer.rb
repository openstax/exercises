class FillInTheBlankAnswer < ActiveRecord::Base
  content(:pre_content)
  content(:post_content)
  numberable

  attr_accessible :blank_answer, :credit

  belongs_to :question

  ##########################
  # Access control methods #
  ##########################
end
