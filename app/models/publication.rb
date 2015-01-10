class Publication < ActiveRecord::Base

  belongs_to :publishable, polymorphic: true
  belongs_to :license

  sortable_has_many :authors, dependent: :destroy
  sortable_has_many :copyright_holders, dependent: :destroy
  sortable_has_many :editors, dependent: :destroy

  sortable_has_many :sources, class_name: 'Derivation',
                    foreign_key: :derived_publication_id, dependent: :destroy,
                    inverse_of: :derived_publication
  has_many :derivations, foreign_key: :source_publication_id,
                         dependent: :destroy,
                         inverse_of: :source_publication

  validates :publishable, presence: true
  validates :publishable_id, uniqueness: { scope: :publishable_type }
  validates :number, presence: true
  validates :version, presence: true, uniqueness: { scope: [
    :number, :publishable_type
  ] }
  validate  :valid_license

  before_validation :assign_number_and_version, on: :create

  default_scope { order{[number.asc, version.desc]} }

  def uid
    "#{number}@#{version}"
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

  def valid_license
    return if license.nil? || license.valid_for?(publishable_type)
    errors.add(:license, "is not valid for #{publishable_type}")
    false
  end

end
