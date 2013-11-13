class ComboChoice < ActiveRecord::Base
  belongs_to :multiple_choice_question
  has_many :combo_simple_choices
  has_many :simple_choices, through: :combo_simple_choices

  attr_accessible :credit, :multiple_choice_question_id
end
