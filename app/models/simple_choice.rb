class SimpleChoice < ActiveRecord::Base
  sortable :multiple_choice_question_id

  belongs_to :multiple_choice_question
  belongs_to :content
  has_many :combo_simple_choices

  attr_accessible :content_id, :credit, :multiple_choice_question_id, :position

  accepts_nested_attributes_for :content

  delegate :can_be_read_by?, 
         :can_be_created_by?, 
         :can_be_updated_by?, 
         :can_be_destroyed_by?, 
         to: :multiple_choice_question
end
