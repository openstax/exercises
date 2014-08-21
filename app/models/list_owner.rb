class ListOwner < ActiveRecord::Base
  belongs_to :list
  belongs_to :owner, polymorphic: true
end
