class ComboChoice < ActiveRecord::Base

  belongs_to :question
  has_one :part, through: :question
  has_one :exercise, through: :part

  has_many :combo_choice_answers, dependent: :destroy
  has_many :answers, through: :combo_choice_answers

  validates :question, presence: true

  delegate_access_control_to :question

end
