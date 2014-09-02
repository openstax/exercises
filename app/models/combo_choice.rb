class ComboChoice < ActiveRecord::Base

  sortable

  belongs_to :question, inverse_of: :combo_choices
  has_one :part, through: :question
  has_one :exercise, through: :part

  has_many :combo_choice_answers, dependent: :destroy, inverse_of: :combo_choice
  has_many :answers, through: :combo_choice_answers

  validates :question, presence: true

  delegate_access_control_to :question

end
