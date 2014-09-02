class ClassLicense < ActiveRecord::Base

  belongs_to :license, inverse_of: :class_licenses

  validates :license, presence: true
  validates :class_name, presence: true, uniqueness: { scope: :license_id }

end
