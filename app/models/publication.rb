class Publication < ActiveRecord::Base

  sort_domain

  belongs_to :publishable, polymorphic: true
  belongs_to :license, inverse_of: :publications

  has_many :sources, class_name: 'Derivation', foreign_key: :derived_publication_id,
           dependent: :destroy, inverse_of: :derived_publication
  has_many :derivations, foreign_key: :source_publication_id,
           dependent: :destroy, inverse_of: :source_publication

  validates :publishable, presence: true
  validates :publishable_id, uniqueness: { scope: :publishable_type }
  validates :number, presence: true
  validates :version, presence: true, uniqueness: { scope: [:number, :publishable_type] }

  before_validation :assign_number_and_version, on: :create

  delegate_access_control_to :publishable

  default_scope lambda { order{[number.asc, version.desc]} }

  scope :for, lambda { |publishable_type, number, version = nil|
    pscope = where(publishable_type: publishable_type, number: number)
    pscope = pscope.where(version: version) unless version.nil?
    pscope.includes(:publishable)
  }

  def uid
    "#{publishable_type.first.downcase}#{number}v#{version}"
  end

  def attribution
    license.attribution_for(publishable)
  end

  def is_published?
    !published_at.nil?
  end

  protected

  def assign_number_and_version
    if number
      self.version = (Publication.where(publishable_type: publishable_type, number: number)
                                 .maximum(:version) || 0) + 1
    else
      self.number = (Publication.where(publishable_type: publishable_type)
                                .maximum(:number) || 0) + 1
      self.version = 1
    end
  end

end
