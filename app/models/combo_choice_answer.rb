class ComboChoiceAnswer < ActiveRecord::Base
  belongs_to :combo_choice
  belongs_to :answer

  delegate_access_control to: :combo_choice
end
