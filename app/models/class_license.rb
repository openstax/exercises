class ClassLicense < ActiveRecord::Base

  sortable :class_name

  belongs_to :license

  validates :license, presence: true
  validates :class_name, presence: true, uniqueness: { scope: :license_id }

end
