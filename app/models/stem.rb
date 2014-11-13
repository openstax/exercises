class Stem < ActiveRecord::Base

  parsable :content
  sort_domain
  stylable

  attr_accessor :temp_id

  belongs_to :question
  has_one :exercise, through: :question

  has_many :stem_answers, dependent: :destroy
  has_many :answers, through: :stem_answers

  has_many :combo_choices, dependent: :destroy
  has_many :combo_choice_answers, through: :combo_choices

  validates :question, presence: true

end
