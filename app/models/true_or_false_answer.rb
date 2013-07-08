class TrueOrFalseAnswer < ActiveRecord::Base
  content
  sortable :question_id

  attr_accessible :is_true, :credit

  belongs_to :question

  validates_presence_of :question

  ##################
  # Access Control #
  ##################
end
