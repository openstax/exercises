class Exercise < ActiveRecord::Base
  attachable
  collaborable
  content
  derivable
  publishable

  attr_accessible :only_embargo_solutions, :credit

  has_many :questions, :dependent => :destroy

  has_many :list_exercises, :dependent => :destroy
  has_many :lists, :through => :list_exercises

  ##################
  # Access Control #
  ##################
end
