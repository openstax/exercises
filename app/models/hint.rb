class Hint < ApplicationRecord

  sortable_belongs_to :question, inverse_of: :hints

  validates :content, presence: true

end
