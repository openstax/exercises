class Publication < ActiveRecord::Base

  belongs_to :publishable, polymorphic: true, inverse_of: :publication
  belongs_to :license

  sortable_has_many :authors, dependent: :destroy, inverse_of: :publication
  sortable_has_many :copyright_holders, dependent: :destroy, inverse_of: :publication
  sortable_has_many :editors, dependent: :destroy, inverse_of: :publication

  sortable_has_many :sources, class_name: 'Derivation',
                              foreign_key: :derived_publication_id,
                              dependent: :destroy,
                              inverse_of: :derived_publication
  has_many :derivations, foreign_key: :source_publication_id,
                         dependent: :destroy,
                         inverse_of: :source_publication

  validates :publishable, presence: true
  validates :publishable_id, uniqueness: { scope: :publishable_type }
  validates :number, presence: true
  validates :version, presence: true, uniqueness: { scope: [:publishable_type, :number] }
  validate  :valid_license, :valid_publishable

  before_validation :assign_number_and_version, on: :create

  default_scope { order{[number.asc, version.desc]} }

  scope :published, -> { where{published_at != nil} }

  def uid
    "#{number}@#{version}"
  end

  def is_yanked?
    !yanked_at.nil?
  end

  def is_published?
    !published_at.nil?
  end

  def is_embargoed?
    !embargoed_until.nil? && embargoed_until >= Time.now
  end

  def is_public?
    is_published? && !is_embargoed? && !is_yanked?
  end

  def has_collaborator?(user)
    authors.any?{|a| a.user == user} || \
    copyright_holders.any?{|ch| ch.user == user} || \
    editors.any?{|e| e.user == user}
  end

  def publish
    self.published_at = Time.now
    self
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
    return if published_at.nil? || license.nil? || license.valid_for?(publishable_type)
    errors.add(:license, "is invalid for #{publishable_type}")
    false
  end

  def valid_publishable
    return if published_at.nil? || publishable.nil?
    publishable.publication_validation
    return if publishable.errors.empty?
    publishable.errors.full_messages.each do |message|
      errors.add(publishable_type.underscore.to_sym, message)
    end
    false
  end

end
