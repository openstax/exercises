class Sort < ActiveRecord::Base

  belongs_to :domain, polymorphic: true
  belongs_to :sortable, polymorphic: true

end
