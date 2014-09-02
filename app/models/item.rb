class Item < ActiveRecord::Base

  sort_domain
  sortable

  belongs_to :question, inverse_of: :items
  has_one :part, through: :question
  has_one :exercise, through: :part

  has_many :answers, as: :answerable, dependent: :destroy

  validates :question, presence: :true

  delegate_access_control_to :question

end
