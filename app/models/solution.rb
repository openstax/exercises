class Solution < ActiveRecord::Base
  attachable :exercise
  collaborable
  content
  derivable
  publishable :question_id

  attr_accessible :summary

  belongs_to :question
  has_one :exercise, :through => :question

  validates_presence_of :question

  ##################
  # Access Control #
  ##################
end
