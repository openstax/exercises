class Formatting < ActiveRecord::Base

  sortable

  belongs_to :formattable, polymorphic: true
  belongs_to :format, inverse_of: :formattings

  validates :format, presence: true
  validates :formattable, presence: true
  validates :formattable_id, uniqueness: { scope: [:formattable_type, :format] }

  delegate_access_control_to :formattable

end
