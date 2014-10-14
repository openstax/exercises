class Formatting < ActiveRecord::Base

  sortable

  belongs_to :formattable, polymorphic: true

  validates :format, presence: true, inclusion: { in: Format.all }
  validates :formattable, presence: true
  validates :formattable_id, uniqueness: { scope: [:formattable_type, :format] }

  delegate_access_control_to :formattable

end
