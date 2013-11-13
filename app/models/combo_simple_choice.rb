class ComboSimpleChoice < ActiveRecord::Base
  belongs_to :combo_choice
  belongs_to :simple_choice

  attr_accessible :combo_choice_id, :simple_choice_id
end
