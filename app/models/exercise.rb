class Exercise < ActiveRecord::Base
  attachable
  collaborable
  content
  publishable

  has_many :questions, :dependent => :destroy

  has_many :list_exercises, :dependent => :destroy
  has_many :lists, :through => :list_exercises

  attr_accessible :only_embargo_solutions, :credit

  ##################
  # Access Control #
  ##################
end
