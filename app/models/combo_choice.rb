class ComboChoice < ActiveRecord::Base

  sortable :question_id

  belongs_to :question, inverse_of: :combo_choices

  has_many :combo_choice_answers, dependent: :destroy, inverse_of: :combo_choice
  has_many :answers, through: :combo_choice_answers

  validates :question, presence: true

end
