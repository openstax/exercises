class Hint < ActiveRecord::Base

  sortable_belongs_to :question, inverse_of: :hints

  validates :question, presence: true
  validates :content, presence: true

end
