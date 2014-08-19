class Answer < ActiveRecord::Base
  belongs_to :question
  has_many :combo_choice_answers, dependent: :destroy

  attr_accessible :content, :correctness, :question_id, :position

  delegate_access_control to: :question
end
