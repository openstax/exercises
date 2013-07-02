class Solution < ActiveRecord::Base
  attachable
  collaborable
  content
  derivable
  publishable(:question)

  attr_accessible :summary

  belongs_to :question

  validates_presence_of :question

  ##################
  # Access Control #
  ##################
end
