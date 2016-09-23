class Publication < ActiveRecord::Base

  belongs_to :publication_group, inverse_of: :publications
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

  delegate :number, :uuid, to: :publication_group

  validates :publishable, presence: true
  validates :publishable_id, uniqueness: { scope: :publishable_type }
  validates :version, presence: true, uniqueness: { scope: :publication_group_id }
  validate  :valid_license, :valid_publication_group

  before_save :before_publication
  after_save :after_publication

  after_initialize :build_publication_group, unless: [:persisted?, :publication_group]
  before_validation :assign_version, on: :create

  default_scope do
    joins(:publication_group).eager_load(:publication_group)
      .order([PublicationGroup.arel_table[:number].asc, arel_table[:version].desc])
  end

  scope :published, -> { where{published_at != nil} }

  scope :latest, ->(published: true) {
    publication_scope = Publication.unscoped
    publication_scope = publication_scope.published if published

    joins{
      publication_scope
        .as(:newer_publication)
        .on{ (newer_publication.publication_group_id == ~publication_group_id) &
             (newer_publication.version > ~version) }
        .outer
    }.where{ newer_publication.id == nil }
  }

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

  def build_publication_group
    self.publication_group = PublicationGroup.new(publishable_type: publishable_type)
  end

  protected

  def assign_version
    self.version ||= (publication_group.publications.maximum(:version) || 0) + 1
  end

  def valid_license
    return if license.nil? || license.valid_for?(publishable_type)
    errors.add(:license, "is invalid for #{publishable_type}")
    false
  end

  def valid_publication_group
    return if publication_group.nil?
    publication_group.publishable_type ||= publishable_type
    return if publication_group.publishable_type == publishable_type
    errors.add(:publication_group, "is invalid for #{publishable_type}")
    false
  end

  def before_publication
    return if published_at.nil? || publishable.nil?
    publishable.before_publication
    return if publishable.errors.empty?
    publishable.errors.full_messages.each do |message|
      errors.add(publishable_type.underscore.to_sym, message)
    end
    false
  end

  def after_publication
    return if published_at.nil? || publishable.nil?
    publishable.after_publication
    return if publishable.errors.empty?
    publishable.errors.full_messages.each do |message|
      errors.add(publishable_type.underscore.to_sym, message)
    end
    false
  end

end
