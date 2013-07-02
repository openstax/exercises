class MultipleChoiceAnswer < ActiveRecord::Base
  content
  numberable(:question)

  attr_accessible :credit

  belongs_to :question

  validates_presence_of :question

  ##################
  # Access Control #
  ##################
end
