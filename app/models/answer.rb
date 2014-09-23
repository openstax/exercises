class Answer < ActiveRecord::Base

  attr_accessor :temp_id

  belongs_to :question, inverse_of: :answers
  has_one :part, through: :question
  has_one :exercise, through: :part

  belongs_to :item, inverse_of: :answers

  has_many :combo_choice_answers, dependent: :destroy, inverse_of: :answer
  has_many :combo_choices, through: :combo_choice_answers

  validates :question, presence: true

  delegate_access_control_to :question

end
