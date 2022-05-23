class License < ApplicationRecord

  has_many :publications
  has_many :class_licenses, dependent: :destroy

  has_many :combined_license_compatibilities,
           class_name: 'LicenseCompatibility',
           foreign_key: 'original_license_id',
           dependent: :destroy,
           inverse_of: :original_license

  has_many :original_license_compatibilities,
           class_name: 'LicenseCompatibility',
           foreign_key: 'combined_license_id',
           dependent: :destroy,
           inverse_of: :combined_license

  validates :name, presence: true, uniqueness: true
  validates :title, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true
  validates :publishing_contract, presence: true
  validates :copyright_notice, presence: true

  def valid_for?(klass_name)
    class_licenses.any?{|cl| cl.class_name == klass_name}
  end

end
