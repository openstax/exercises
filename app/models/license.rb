class License < ActiveRecord::Base

  sortable

  has_many :publications, :inverse_of => :license

  has_many :combined_license_compatibilities, class_name: 'LicenseCompatibility',
           dependent: :destroy, inverse_of: :original_license
  has_many :combined_compatible_licenses, through: :combined_license_compatibilities,
           source: :combined_license

  has_many :original_license_compatibilities, class_name: 'LicenseCompatibility',
           dependent: :destroy, inverse_of: :combined_license
  has_many :original_compatible_licenses, through: :original_license_compatibilities,
           source: :original_license

  validates :name, presence: true, uniqueness: true
  validates :short_name, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true
  validates :publishing_contract, presence: true
  validates :copyright_notice, presence: true

  scope :for_exercises, where(:allows_exercises => true)
  scope :for_solutions, where(:allows_solutions => true)

  def valid_for?(publishable)
    case publishable.class
    when Exercise
      allows_exercises
    when Solution
      allows_solutions
    else
      false
    end
  end

  def self.options_for(publishable)
    case publishable.class
    when Exercise
      pscope = for_exercises
    when Solution
      pscope = for_solutions
    else
      pscope = none
    end
    pscope.all.collect{|l| [l.short_name, l.id]}
  end

end
