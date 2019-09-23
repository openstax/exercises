class Publication < ApplicationRecord

  belongs_to :publication_group, inverse_of: :publications
  belongs_to :publishable, polymorphic: true, inverse_of: :publication, touch: true
  belongs_to :license, optional: true

  sortable_has_many :authors, dependent: :destroy, inverse_of: :publication
  sortable_has_many :copyright_holders, dependent: :destroy, inverse_of: :publication

  sortable_has_many :sources, class_name: 'Derivation',
                              foreign_key: :derived_publication_id,
                              dependent: :destroy,
                              inverse_of: :derived_publication
  has_many :derivations, foreign_key: :source_publication_id,
                         dependent: :destroy,
                         inverse_of: :source_publication

  delegate :group_uuid, :number, :nickname, :nickname=, to: :publication_group

  validates :publishable_id, uniqueness: { scope: :publishable_type }
  validates :uuid, presence: true, uniqueness: true
  validates :version, presence: true, uniqueness: { scope: :publication_group_id },
                      numericality: { only_integer: true, greater_than: 0 }
  validate  :valid_license, :valid_publication_group

  before_save :before_publication
  after_save :after_publication

  after_initialize :build_publication_group, if: :new_record?, unless: :publication_group
  before_validation :assign_uuid_and_version

  default_scope { order(version: :desc) }

  scope :published,   -> { where.not(published_at: nil) }

  scope :unpublished, -> { where(published_at: nil) }

  scope :with_id, ->(id) do
    nn, vv = id.to_s.split('@')

    pub = arel_table
    pubg = PublicationGroup.arel_table

    wheres = pubg[:uuid].eq(nn).or(pubg[:number].eq(nn))
    latest = false
    case vv
    when NilClass
      wheres = wheres.or(pub[:uuid].eq(nn)).and(pub[:published_at].not_eq(nil))
    when 'draft', 'd'
      wheres = wheres.and(pub[:published_at].eq(nil))
    when 'latest'
      latest = true
    else
      wheres = wheres.and(pub[:version].eq(vv))
    end

    rel = joins(:publication_group).where(wheres)
    rel = rel.chainable_latest if latest
    rel.order(pubg[:number].asc, pub[:version].desc)
  end

  scope :visible_for, ->(options) do
    user = options[:user]
    user = user.human_user if user.is_a?(OpenStax::Api::ApiUser)
    next published if !user.is_a?(User) || user.is_anonymous?
    next all if user.is_administrator?

    user_id = user.id

    pub = arel_table
    au = Author.arel_table
    cw = CopyrightHolder.arel_table
    dg = Delegation.arel_table

    left_outer_joins(:authors, :copyright_holders).where(
      pub[:published_at].not_eq(nil).or(
        au[:user_id].eq(user_id)
      ).or(
        cw[:user_id].eq(user_id)
      ).or(
        Delegation.where(
          delegate_id: user_id, delegate_type: user.class.name, can_read: true
        ).where(
          dg[:delegator_id].eq(au[:user_id]).or(dg[:delegator_id].eq(cw[:user_id]))
        ).arel.exists
      )
    )
  end

  # By default, returns both the latest published version and the latest draft, if any
  # Chain to the published, unpublished or visible_for scopes
  scope :chainable_latest, -> do
    joins(:publication_group).where(
      <<-WHERE_SQL.strip_heredoc
        "publication_groups"."latest_published_version" IS NULL
          OR "publications"."version" >= "publication_groups"."latest_published_version"
      WHERE_SQL
    )
  end

  # Returns only the latest version (published or draft) for each PublicationGroup
  # Do not chain to published, unpublished or visible_for scopes
  scope :latest, -> do
    joins(:publication_group).where(
      <<-WHERE_SQL.strip_heredoc
        "publication_groups"."latest_version" IS NULL
          OR "publications"."version" = "publication_groups"."latest_version"
      WHERE_SQL
    )
  end

  def delegations
    (authors + copyright_holders).map(&:user).uniq.flat_map(&:delegations_as_delegator)
  end

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

  def is_chainable_latest?
    version.nil? || version >= publication_group.latest_published_version
  end

  def is_latest?
    version.nil? || version == publication_group.latest_version
  end

  def collaborators(preload: nil)
    preload = preload.nil? ? :user : { user: preload }

    # Don't preload if creating/deleting the publication
    aa = persisted? ? authors.preload(preload) : authors
    ch = persisted? ? copyright_holders.preload(preload) : copyright_holders

    aa.map(&:user) + ch.map(&:user)
  end

  def has_collaborator?(user)
    collaborators.include? user
  end

  def has_read_permission?(user)
    has_collaborator?(user) ||
    authors.joins(user: :delegations_as_delegator).where(user: {
      delegations_as_delegator: {
        can_read: true,
        delegate_id: user.id,
        delegate_type: user.class.name
      }
    }).exists? ||
    copyright_holders.joins(user: :delegations_as_delegator).where(user: {
      delegations_as_delegator: {
        can_read: true,
        delegate_id: user.id,
        delegate_type: user.class.name
      }
    }).exists?
  end

  def has_write_permission?(user)
    has_collaborator?(user) ||
    authors.joins(user: :delegations_as_delegator).where(user: {
      delegations_as_delegator: {
        can_update: true,
        delegate_id: user.id,
        delegate_type: user.class.name
      }
    }).exists? ||
    copyright_holders.joins(user: :delegations_as_delegator).where(user: {
      delegations_as_delegator: {
        can_update: true,
        delegate_id: user.id,
        delegate_type: user.class.name
      }
    }).exists?
  end

  def publish
    self.published_at = Time.now
    self
  end

  def build_publication_group
    return if publishable_type.nil?

    self.publication_group = PublicationGroup.new(publishable_type: publishable_type)
  end

  def assign_uuid_and_version
    self.uuid ||= SecureRandom.uuid
    return if publication_group.nil?

    self.version ||= (publication_group.publications.maximum(:version) || 0) + 1

    publication_group.assign_uuid_and_number
    publication_group.new_record? ? publication_group.latest_version = version :
                                    publication_group.update_attribute(:latest_version, version)
  end

  protected

  def valid_license
    return if license.nil? || license.valid_for?(publishable_type)

    errors.add(:license, "is invalid for #{publishable_type}")
    throw(:abort)
  end

  def valid_publication_group
    return if publication_group.nil?

    publication_group.publishable_type ||= publishable_type

    return if publication_group.publishable_type == publishable_type && publication_group.valid?

    errors.add(:publication_group, "is invalid for #{publishable_type}") \
      if publication_group.publishable_type != publishable_type
    publication_group.errors.each { |attribute, error| errors.add attribute, error }
    throw(:abort)
  end

  def before_publication
    return if published_at.nil? || publishable.nil?

    catch(:abort) do
        publishable.before_publication
    end

    return if publishable.errors.empty?

    publishable.errors.full_messages.each do |message|
      errors.add(publishable_type.underscore.to_sym, message)
    end

    throw(:abort)
  end

  def after_publication
    return if published_at.nil? || publishable.nil?

    publishable.after_publication
    if publishable.errors.empty?
      publication_group.update_attribute(:latest_published_version, version) \
        if publication_group.latest_published_version.nil? ||
           publication_group.latest_published_version < version

      return
    end

    publishable.errors.full_messages.each do |message|
      errors.add(publishable_type.underscore.to_sym, message)
    end

    throw(:abort)
  end

end
