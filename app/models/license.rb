class License < ActiveRecord::Base
  sortable

  has_many :exercises, :inverse_of => :license
  has_many :solutions, :inverse_of => :license

  attr_accessible :name, :short_name, :url, :partial_name

  validates_presence_of :name, :short_name, :url, :partial_name

  ##################
  # Access Control #
  ##################
end
