class MatchingAnswer < ActiveRecord::Base
  content
  numberable

  attr_accessible :match_number, :right_column, :credit

  belongs_to :question

  ##########################
  # Access control methods #
  ##########################
end
