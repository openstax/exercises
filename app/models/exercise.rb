class Exercise < ActiveRecord::Base
  attr_accessible :content, :license_id, :suggested_credit, :only_embargo_solutions

  
end
