class ComboChoice < ApplicationRecord

  belongs_to :stem

  has_many :combo_choice_answers, dependent: :destroy

  validates :correctness, presence: true, numericality: { greater_than_or_equal_to: 0.0,
                                                          less_than_or_equal_to: 1.0 }

end
