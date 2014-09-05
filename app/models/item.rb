class Item < ActiveRecord::Base

  sort_domain
  sortable

  belongs_to :question, inverse_of: :items
  has_one :part, through: :question
  has_one :exercise, through: :part

  has_many :answers, dependent: :destroy, inverse_of: :item
  has_many :combo_choices, dependent: :destroy, inverse_of: :item

  validates :question, presence: :true

  delegate_access_control_to :question

end
