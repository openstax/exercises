class LicenseCompatibility < ApplicationRecord

  belongs_to :original_license, class_name: 'License',
                                inverse_of: :combined_license_compatibilities
  belongs_to :combined_license, class_name: 'License',
                                inverse_of: :original_license_compatibilities

  validates :combined_license, uniqueness: { scope: :original_license_id }

end
