class License < ActiveRecord::Base
  attr_accessible :is_default, :long_name, :partial_name, :short_name, :url
end
