class Answer < ActiveRecord::Base

  attr_accessor :temp_id

  parsable :content

  belongs_to :question

  has_many :stem_answers, dependent: :destroy

  has_many :combo_choice_answers, dependent: :destroy

  validates :question, presence: true
  validates :content, presence: true

end
