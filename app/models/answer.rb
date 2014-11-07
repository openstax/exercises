class Answer < ActiveRecord::Base

  attr_accessor :temp_id

  parsable :content

  belongs_to :question
  has_one :part, through: :question
  has_one :exercise, through: :part

  belongs_to :item

  has_many :combo_choice_answers, dependent: :destroy
  has_many :combo_choices, through: :combo_choice_answers

  validates :question, presence: true

  delegate_access_control_to :question

end
