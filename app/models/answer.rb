class Answer < ActiveRecord::Base

  sortable :answerable_id, :answerable_type

  belongs_to :answerable, polymorphic: true

  has_many :combo_choice_answers, dependent: :destroy, inverse_of: :answer
  has_many :combo_choices, through: :combo_choice_answers

  validates :answerable, presence: true

  delegate_access_control_to :answerable

end
