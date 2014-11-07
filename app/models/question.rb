class Question < ActiveRecord::Base

  parsable :stem
  sort_domain

  attr_accessor :temp_id

  belongs_to :part
  has_one :exercise, through: :part

  has_many :solutions, dependent: :destroy

  has_many :items, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :combo_choices, dependent: :destroy

  validates :part, presence: true

  delegate_access_control_to :part

end
