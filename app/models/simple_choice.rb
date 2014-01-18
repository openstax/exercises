class SimpleChoice < ActiveRecord::Base
  acts_as_numberable container: :multiple_choice_question,
                     number_field: :position

  belongs_to :multiple_choice_question
  belongs_to :content, dependent: :destroy
  has_many :combo_simple_choices, dependent: :destroy

  attr_accessible :content_id, :credit, :multiple_choice_question_id, :position

  accepts_nested_attributes_for :content

  delegate_access_control to: :multiple_choice_question,
                          include_sort: true
end
