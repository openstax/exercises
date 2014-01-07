class MultipleChoiceQuestion < ActiveRecord::Base
  has_one :question, as: :format

  belongs_to :stem, class_name: 'Content'
  has_many :simple_choices
  has_many :combo_choices

  attr_accessible :can_select_multiple, :stem_id

  accepts_nested_attributes_for :stem

  delegate :can_be_read_by?, 
           :can_be_created_by?, 
           :can_be_updated_by?, 
           :can_be_destroyed_by?, 
           to: :question
end
