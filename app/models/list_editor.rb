class ListEditor < ActiveRecord::Base
  belongs_to :list
  belongs_to :editor, polymorphic: true
end
