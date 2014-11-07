class Item < ActiveRecord::Base

  attr_accessor :temp_id

  parsable :content

  belongs_to :question
  has_one :part, through: :question
  has_one :exercise, through: :part

  has_many :answers, dependent: :destroy

  validates :question, presence: :true

  delegate_access_control_to :question

end
