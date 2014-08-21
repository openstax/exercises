class Answer < ActiveRecord::Base
  belongs_to :question
  has_many :combo_choice_answers, dependent: :destroy

  delegate_access_control to: :question
end
