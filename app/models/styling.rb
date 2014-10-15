class Styling < ActiveRecord::Base

  sortable

  belongs_to :stylable, polymorphic: true

  validates :stylable, presence: true
  validates :style, presence: true, inclusion: { in: Style.all },
                    uniqueness: { scope: [:stylable_type, :stylable_id] }

  delegate_access_control_to :stylable

end
