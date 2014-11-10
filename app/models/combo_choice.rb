class ComboChoice < ActiveRecord::Base

  belongs_to :stem
  has_one :question, through: :stem
  has_one :exercise, through: :question

  has_many :combo_choice_answers, dependent: :destroy
  has_many :answers, through: :combo_choice_answers

  validates :stem, presence: true
  validates :correctness, presence: true, numericality: true

end
