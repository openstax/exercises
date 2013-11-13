class SimpleChoice < ActiveRecord::Base
  belongs_to :multiple_choice_question
  has_many :combo_simple_choices

  attr_accessible :content_id, :credit, :multiple_choice_question_id, :position
end
