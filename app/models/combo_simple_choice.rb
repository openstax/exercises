class ComboSimpleChoice < ActiveRecord::Base
  belongs_to :combo_choice
  belongs_to :simple_choice

  attr_accessible :combo_choice_id, :simple_choice_id

  delegate :can_be_read_by?, 
           :can_be_created_by?, 
           :can_be_updated_by?, 
           :can_be_destroyed_by?, 
           to: :combo_choice
end
