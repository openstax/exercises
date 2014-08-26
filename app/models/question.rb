class Question < ActiveRecord::Base

  sortable :part_id

  belongs_to :part, :inverse_of => :questions

  has_many :formattable_formats, as: :formattable, dependent: :destroy

  validates :part, presence: true

  delegate_access_control_to :part

end
