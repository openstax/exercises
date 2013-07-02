class ShortAnswer < ActiveRecord::Base
  content
  numberable(:question)

  attr_accessible :short_answer, :credit

  belongs_to :question

  validates_presence_of :question

  ##################
  # Access Control #
  ##################
end
