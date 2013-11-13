class MultipleChoiceQuestion < ActiveRecord::Base
  has_one :question, as: :format

  has_many :simple_choices
  has_many :combo_choices

  attr_accessible :can_select_multiple, :stem_id
end
