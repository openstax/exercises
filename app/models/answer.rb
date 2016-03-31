class Answer < ActiveRecord::Base

  attr_accessor :temp_id

  user_html :content

  sortable_belongs_to :question, inverse_of: :answers

  has_many :stem_answers, dependent: :destroy

  has_many :combo_choice_answers, dependent: :destroy

  validates :question, presence: true
  validates :content, presence: true

  def temp_id!
    self.temp_id ||= SecureRandom.hex(8)
  end

end
