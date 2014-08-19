class ComboChoiceAnswer < ActiveRecord::Base
  belongs_to :combo_choice
  belongs_to :answer

  attr_accessible :combo_choice_id, :answer_id

  delegate_access_control to: :combo_choice
  
end
