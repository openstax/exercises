class Hint < ActiveRecord::Base

  sortable_belongs_to :question

  validates :question, presence: true

end
