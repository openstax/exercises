class License < ActiveRecord::Base

  sort_domain

  has_many :publications, dependent: :destroy

  has_many :class_licenses, dependent: :destroy

  has_many :combined_license_compatibilities,
           class_name: 'LicenseCompatibility', dependent: :destroy
  has_many :combined_compatible_licenses,
           through: :combined_license_compatibilities,
           source: :combined_license

  has_many :original_license_compatibilities,
           class_name: 'LicenseCompatibility', dependent: :destroy
  has_many :original_compatible_licenses,
           through: :original_license_compatibilities,
           source: :original_license

  validates :name, presence: true, uniqueness: true
  validates :title, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true
  validates :publishing_contract, presence: true
  validates :copyright_notice, presence: true

  scope :for, lambda { |publishable|
    joins(:class_licenses).where(class_licenses: {class_name: publishable.class.name}) }

  def self.options_for(publishable)
    self.for(publishable).collect{|l| [l.title, l.id]}
  end

  def valid_for?(klass_name)
    class_licenses.any?{|cl| cl.class_name == klass_name}
  end

end
