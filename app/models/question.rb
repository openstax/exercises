class Question < ActiveRecord::Base

  sortable :part_id

  belongs_to :part, :inverse_of => :questions

  has_many :formattings, as: :formattable, dependent: :destroy
  has_many :formats, through: :formattings

  has_many :solutions, dependent: :destroy, inverse_of: :question

  has_many :items, dependent: :destroy, inverse_of: :question

  validates :part, presence: true

  delegate_access_control_to :part

end
