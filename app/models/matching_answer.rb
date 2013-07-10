class MatchingAnswer < ActiveRecord::Base
  attachable :exercise
  content
  sortable :question_id

  attr_accessible :match_number, :right_column, :credit

  belongs_to :question
  has_one :exercise, :through => :question

  validates_presence_of :question, :match_number
  validates_uniqueness_of :right_column, :scope => [:question_id, :match_number]

  ##################
  # Access Control #
  ##################
end
