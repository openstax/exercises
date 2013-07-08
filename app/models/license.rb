class License < ActiveRecord::Base
  sortable

  attr_accessible :name, :short_name, :url, :partial_name

  has_many :exercises, :solutions

  validates_presence_of :name, :short_name, :url, :partial_name

  ##################
  # Access Control #
  ##################
end
