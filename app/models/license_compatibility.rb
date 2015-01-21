class LicenseCompatibility < ActiveRecord::Base

  belongs_to :original_license, class_name: 'License',
                                inverse_of: :combined_license_compatibilities
  belongs_to :combined_license, class_name: 'License',
                                inverse_of: :original_license_compatibilities

  validates :original_license, presence: true
  validates :combined_license, presence: true,
                               uniqueness: { scope: :original_license_id }

end
