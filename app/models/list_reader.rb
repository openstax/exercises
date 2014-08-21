class ListReader < ActiveRecord::Base
  belongs_to :list
  belongs_to :reader, polymorphic: true
end
