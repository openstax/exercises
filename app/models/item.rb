class Item < ActiveRecord::Base

  sortable :question_id

  belongs_to :question, inverse_of: :items

  has_many :answers, inverse_of: :item

  validates :question, presence: :true

end
