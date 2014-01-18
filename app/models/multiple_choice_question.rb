class MultipleChoiceQuestion < ActiveRecord::Base
  has_one :question, as: :format

  belongs_to :stem, class_name: 'Content', dependent: :destroy
  has_many :simple_choices, dependent: :destroy
  has_many :combo_choices, dependent: :destroy

  attr_accessible :can_select_multiple, :stem_id

  accepts_nested_attributes_for :stem

  delegate_access_control to: :question
end
