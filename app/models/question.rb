class Question < ActiveRecord::Base

  sort_domain
  sortable

  belongs_to :part, inverse_of: :questions
  has_one :exercise, through: :part

  has_many :formattings, as: :formattable, dependent: :destroy
  has_many :formats, through: :formattings

  has_many :solutions, dependent: :destroy, inverse_of: :question

  has_many :items, dependent: :destroy, inverse_of: :question
  has_many :answers, through: :items
  has_many :combo_choices, through: :items

  validates :part, presence: true

  delegate_access_control_to :part

end
