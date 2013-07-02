class Solution < ActiveRecord::Base
  attachable
  collaborable
  content
  derivable
  publishable

  attr_accessible :summary

  belongs_to :question

  ##########################
  # Access control methods #
  ##########################
end
