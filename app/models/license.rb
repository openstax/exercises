class License < ActiveRecord::Base
  sortable

  has_many :exercises, :solutions

  attr_accessible :name, :short_name, :url, :partial_name

  validates_presence_of :name, :short_name, :url, :partial_name

  ##################
  # Access Control #
  ##################
end
