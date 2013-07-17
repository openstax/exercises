class Solution < ActiveRecord::Base
  attachable
  content
  publishable :question_id

  add_prepublish_check(:has_blank_content?, false, 'The contents of this solution are blank.')

  belongs_to :question, :inverse_of => :solutions
  has_one :exercise, :through => :question

  attr_accessible :summary

  validates_presence_of :question
  validates_presence_of :summary

  def has_blank_content?
    content.blank?
  end

  ##################
  # Access Control #
  ##################
end
