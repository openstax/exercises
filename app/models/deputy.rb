class Deputy < ActiveRecord::Base
  belongs_to :deputizer
  belongs_to :deputy
  # attr_accessible :title, :body
end
