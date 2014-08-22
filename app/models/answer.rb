class Answer < ActiveRecord::Base

  sortable :question_id

  belongs_to :question, inverse_of: :answers
  has_one :part, through: :question
  has_one :exercise, through: :question

  belongs_to :item, inverse_of: :answers

  has_many :answer_formats, dependent: :destroy, inverse_of: :answer
  has_many :formats, through: :answer_formats

  has_many :combo_choice_answers, dependent: :destroy, inverse_of: :answer
  has_many :combo_choices, through: :combo_choice_answers

  validates :question, presence: true

end
