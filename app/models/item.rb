class Item < ActiveRecord::Base

  sortable :question_id

  belongs_to :question, inverse_of: :items

  has_many :answers, as: :answerable, dependent: :destroy

  validates :question, presence: :true

end
