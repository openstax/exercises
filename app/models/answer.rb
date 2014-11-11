class Answer < ActiveRecord::Base

  attr_accessor :temp_id

  parsable :content

  belongs_to :question
  has_one :exercise, through: :question

  has_many :stem_answers, dependent: :destroy
  has_many :stems, through: :stem_answers

  has_many :combo_choice_answers, dependent: :destroy
  has_many :combo_choices, through: :combo_choice_answers

  validates :question, presence: true
  validates :content, presence: true

end
