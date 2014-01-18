class ComboChoice < ActiveRecord::Base
  belongs_to :multiple_choice_question
  has_many :combo_simple_choices, dependent: :destroy
  has_many :simple_choices, through: :combo_simple_choices

  attr_accessible :credit, :multiple_choice_question_id

  validates_presence_of :multiple_choice_question

  delegate_access_control to: :multiple_choice_question

end
