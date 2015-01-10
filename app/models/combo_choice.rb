class ComboChoice < ActiveRecord::Base

  belongs_to :stem

  has_many :combo_choice_answers, dependent: :destroy

  validates :stem, presence: true
  validates :correctness, presence: true, numericality: true

end
