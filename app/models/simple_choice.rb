class SimpleChoice < ActiveRecord::Base
  acts_as_numberable container: :multiple_choice_question,
                     number_field: :position

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

  def can_be_sorted_by?(user)
    multiple_choice_question.can_be_updated_by?(user)
  end
end
