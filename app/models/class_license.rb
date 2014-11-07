class ClassLicense < ActiveRecord::Base

  belongs_to :license

  validates :license, presence: true
  validates :class_name, presence: true, uniqueness: { scope: :license_id }

end
