class ComboChoice < ActiveRecord::Base
  belongs_to :question
  has_many :combo_choice_answers, dependent: :destroy
  has_many :answers, through: :combo_choice_answers

  validates_presence_of :question

  delegate_access_control to: :question
end
