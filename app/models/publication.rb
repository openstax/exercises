class Publication < ActiveRecord::Base
  belongs_to :publishable
  belongs_to :license
end
