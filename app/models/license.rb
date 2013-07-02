class License < ActiveRecord::Base
  numberable

  attr_accessible :short_name, :long_name, :partial_name, :url

  has_many :exercises, :solutions

  ##########################
  # Access control methods #
  ##########################
end
