class Solution < ActiveRecord::Base
  attachable :exercise
  collaborable
  content
  publishable :question_id

  belongs_to :question
  has_one :exercise, :through => :question

  attr_accessible :summary

  validates_presence_of :question

  ##################
  # Access Control #
  ##################
end
