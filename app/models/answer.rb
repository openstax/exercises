class Answer < ActiveRecord::Base

  belongs_to :item, inverse_of: :answers
  has_one :question, through: :item
  has_one :part, through: :question
  has_one :exercise, through: :part

  has_many :combo_choice_answers, dependent: :destroy, inverse_of: :answer
  has_many :combo_choices, through: :combo_choice_answers

  validates :item, presence: true

  delegate_access_control_to :item

end
