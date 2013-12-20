class ComboChoice < ActiveRecord::Base
  belongs_to :multiple_choice_question
  has_many :combo_simple_choices
  has_many :simple_choices, through: :combo_simple_choices

  attr_accessible :credit, :multiple_choice_question_id

  validates_presence_of :multiple_choice_question

  delegate :can_be_read_by?, 
       :can_be_created_by?, 
       :can_be_updated_by?, 
       :can_be_destroyed_by?, 
       to: :multiple_choice_question
end
