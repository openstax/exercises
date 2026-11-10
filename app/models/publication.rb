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
                         inverse_of: :source_publication

  delegate :group_uuid, :number, :nickname, :nickname=,
           :solutions_are_public, :solutions_are_public=, to: :publication_group

  validates :publishable_id, uniqueness: { scope: :publishable_type }
  validates :uuid, presence: true, uniqueness: true
  validates :version, presence: true, uniqueness: { scope: :publication_group_id },
                      numericality: { only_integer: true, greater_than: 0 }
  validate  :valid_license, :valid_publication_group

  before_save :before_publication
  after_save :after_publication
  after_destroy :update_latest_version

  after_initialize :build_publication_group, if: :new_record?, unless: :publication_group
  before_validation :assign_uuid_and_version

  default_scope { order(version: :desc) }

  scope :published,   -> { where.not(published_at: nil) }

  scope :unpublished, -> { where(published_at: nil) }

  scope :with_id, ->(id) do
    number_or_uuid, version = id.to_s.split('@')
    number = Integer(number_or_uuid) rescue nil

    join_rel = joins(:publication_group)
    or_rel = join_rel.where(publication_group: { uuid: number_or_uuid })
    or_rel = or_rel.or(join_rel.where(publication_group: { number: number })) unless number.nil?

    rel = case version
    when NilClass
      join_rel.where(uuid: number_or_uuid).or(or_rel.published)
    when 'draft', 'd'
      or_rel.unpublished
    when 'latest'
      or_rel.chainable_latest
    else
      or_rel.where(version: version)
    end

    rel.order('"publication_group"."number" ASC').order(version: :desc)
  end

  scope :visible_for, ->(options) do
    user = options[:user]
    user = user.human_user if user.is_a?(OpenStax::Api::ApiUser)
    next published if !user.is_a?(User) || user.is_anonymous?
    next all if user.is_administrator?

    user_id = user.id

    dg = Delegation.arel_table
    au = Author.arel_table
    cw = CopyrightHolder.arel_table

    rel = left_outer_joins(:authors, :copyright_holders)
    rel = rel.where.not(published_at: nil).or(
      rel.where(authors: { user_id: user_id })
    ).or(
      rel.where(copyright_holders: { user_id: user_id })
    ).or(
      rel.where(
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
    joins(:publication_group).where.not(
      publication_group: { id: nil } # Rails 6.1 workaround
    ).where(
      <<-WHERE_SQL.strip_heredoc
        "publication_group"."latest_published_version" IS NULL
          OR "publications"."version" >= "publication_group"."latest_published_version"
      WHERE_SQL
    )
  end

  # Returns only the latest version (published or draft) for each PublicationGroup
  # Do not chain to published, unpublished or visible_for scopes
  scope :latest, -> do
    joins(:publication_group).where.not(
      publication_group: { id: nil } # Rails 6.1 workaround
    ).where(
      <<-WHERE_SQL.strip_heredoc
        "publication_group"."latest_version" IS NULL
          OR "publications"."version" = "publication_group"."latest_version"
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

  # Checks the database for another version in the same group with a higher version number.
  def has_newer_version?
    return false if version.nil? || publication_group.nil? || publication_group.new_record?

    publication_group.publications.where('"publications"."version" > ?', version).exists?
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
    authors.joins(user: :delegations_as_delegator).where(delegations_as_delegator: {
      can_read: true,
      delegate_id: user.id,
      delegate_type: user.class.name
    }).exists? ||
    copyright_holders.joins(user: :delegations_as_delegator).where(delegations_as_delegator: {
      can_read: true,
      delegate_id: user.id,
      delegate_type: user.class.name
    }).exists?
  end

  def has_write_permission?(user)
    has_collaborator?(user) ||
    authors.joins(user: :delegations_as_delegator).where(delegations_as_delegator: {
      can_update: true,
      delegate_id: user.id,
      delegate_type: user.class.name
    }).exists? ||
    copyright_holders.joins(user: :delegations_as_delegator).where(delegations_as_delegator: {
      can_update: true,
      delegate_id: user.id,
      delegate_type: user.class.name
    }).exists?
  end

  def publish
    self.published_at = Time.now
    self
  end

  def build_publication_group
    return if publishable_type.nil?

    self.publication_group = PublicationGroup.new publishable_type: publishable_type
  end

  def assign_uuid_and_version
    self.uuid ||= SecureRandom.uuid
    return if publication_group.nil?

    self.version ||= (publication_group.publications.maximum(:version) || 0) + 1

    publication_group.assign_uuid_and_number
    # Only creating a version can change latest_version. Saving an existing version, such as
    # publishing an old draft, must not move it back down.
    return unless new_record?

    if publication_group.new_record?
      publication_group.latest_version = version
    else
      update_group_version_if_higher(:latest_version, version)
    end
  end

  protected

  # Updates the publication group's version column in the database only if the new value is higher,
  # so a publication group loaded before a newer version was saved can't lower it.
  # Then copies the database value into the in-memory publication group without marking it changed,
  # so saving that publication group later doesn't write a stale value back.
  def update_group_version_if_higher(column, value)
    PublicationGroup.unscoped.where(id: publication_group.id)
                    .where("#{column} IS NULL OR #{column} < ?", value)
                    .update_all(column => value)
    publication_group[column] = PublicationGroup.where(id: publication_group.id).pick(column)
    publication_group.clear_attribute_changes([ column ])
  end

  # A deleted draft may have been the latest version, which would leave latest_version pointing at a
  # version that no longer exists. Point it at the highest version left instead.
  # If no versions are left, there is nothing for it to point to, so it is left unchanged.
  def update_latest_version
    highest_version = Publication.unscoped.where(publication_group_id: publication_group_id).maximum(:version)
    return if highest_version.nil?

    PublicationGroup.unscoped.where(id: publication_group_id).update_all(latest_version: highest_version)
    publication_group.latest_version = highest_version
    publication_group.clear_attribute_changes([ :latest_version ])
  end

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
    publication_group.errors.each { |error| errors.add error.attribute, error.message }
    throw(:abort)
  end

  def before_publication
    return if published_at.nil? || publishable.nil?

    # Publishing an old draft would publish content older than a version that already exists.
    if published_at_in_database.nil? && has_newer_version?
      errors.add(:base, 'cannot be published because a newer version exists')
      throw(:abort)
    end

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
      update_group_version_if_higher(:latest_published_version, version)

      return
    end

    publishable.errors.full_messages.each do |message|
      errors.add(publishable_type.underscore.to_sym, message)
    end

    throw(:abort)
  end

end
