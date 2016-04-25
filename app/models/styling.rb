class Styling < ActiveRecord::Base

  belongs_to :stylable, polymorphic: true, inverse_of: :stylings

  validates :stylable, presence: true
  validates :style, presence: true, inclusion: { in: Style.all },
                    uniqueness: { scope: [:stylable_type, :stylable_id] }

end
