class Publication < ActiveRecord::Base

  belongs_to :publication_group, inverse_of: :publications
  belongs_to :publishable, polymorphic: true, inverse_of: :publication
  belongs_to :license

  sortable_has_many :authors, dependent: :destroy, inverse_of: :publication
  sortable_has_many :copyright_holders, dependent: :destroy, inverse_of: :publication

  sortable_has_many :sources, class_name: 'Derivation',
                              foreign_key: :derived_publication_id,
                              dependent: :destroy,
                              inverse_of: :derived_publication
  has_many :derivations, foreign_key: :source_publication_id,
                         dependent: :destroy,
                         inverse_of: :source_publication

  delegate :group_uuid, :number, to: :publication_group

  validates :publication_group, :publishable, presence: true
  validates :publishable_id, uniqueness: { scope: :publishable_type }
  validates :uuid, presence: true, uniqueness: true
  validates :version, presence: true, uniqueness: { scope: :publication_group_id }
  validate  :valid_license, :valid_publication_group

  before_save :before_publication
  after_save :after_publication

  after_initialize :build_publication_group, if: :new_record?, unless: :publication_group
  before_validation :assign_uuid_and_version, on: :create

  default_scope do
    joins(:publication_group).eager_load(:publication_group)
      .order([PublicationGroup.arel_table[:number].asc, arel_table[:version].desc])
  end

  scope :published, -> { where{published_at != nil} }

  scope :unpublished, -> { where{published_at == nil} }

  scope :with_id, ->(id) {
    nn, vv = id.to_s.split('@')

    joins(:publication_group).where do
      wheres = (publication_group.uuid == nn) | (publication_group.number == nn)

      case vv
      when NilClass
        (wheres | (uuid == nn)) & (published_at != nil)
      when 'draft', 'd'
        wheres & (published_at == nil)
      when 'latest'
        wheres
      else
        wheres & (version == vv)
      end
    end.order {[publication_group.number.asc, version.desc]}
  }

  scope :visible_for, ->(user) {
    user = user.human_user if user.is_a?(OpenStax::Api::ApiUser)
    next published if !user.is_a?(User) || user.is_anonymous?
    next all if user.administrator
    user_id = user.id

    joins do
      [
        authors,
        copyright_holders,
        publication_group.list_publication_groups.outer.list.outer.list_owners,
        publication_group.list_publication_groups.outer.list.outer.list_editors,
        publication_group.list_publication_groups.outer.list.outer.list_readers
      ].map(&:outer)
    end.where do
      (published_at  != nil                                                        ) |
      (authors.user_id           == user_id                                        ) |
      (copyright_holders.user_id == user_id                                        ) |
      ((list_owners.owner_id     == user_id) & (list_owners.owner_type   == 'User')) |
      ((list_editors.editor_id   == user_id) & (list_editors.editor_type == 'User')) |
      ((list_readers.reader_id   == user_id) & (list_readers.reader_type == 'User'))
    end
  }

  # The scope option determines how we limit the search for more recent versions
  # Default scope: Publication.published
  #
  # Examples:
  #
  # Publication.all.latest or Publication.all.latest(scope: Publication.published)
  # will return both the latest published versions and drafts made after them
  #
  # Publication.published.latest or Publication.published.latest(scope: Publication.published)
  # will return only the latest published versions (no drafts)
  #
  # Publication.unpublished.latest or Publication.unpublished.latest(scope: Publication.published)
  # will return only drafts made after the latest published versions
  # (could return more than 1, but the draft code makes it so there's always only 1 draft)
  #
  # Publication.all.latest(scope: Publication.all)
  # will return any drafts made after the latest published version if they exist,
  # or the latest published version if there are no drafts (but not both)
  #
  # Publication.published.latest(scope: Publication.all)
  # will return only latest published versions that don't have drafts made after them
  #
  # Publication.unpublished.latest(scope: Publication.all)
  # will return only drafts made after the latest published versions
  # (guaranteed to return only the latest draft)
  scope :latest, ->(scope: nil) do
    scope ||= published

    where.not(
      scope
        .reorder(nil).limit(nil).offset(nil)
        .from('"publications" "newer_pub"')
        .where(
          <<-WHERE_SQL.strip_heredoc
            "newer_pub"."publication_group_id" = "publications"."publication_group_id"
            AND "newer_pub"."version" > "publications"."version"
          WHERE_SQL
        )
        .exists
    )
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

  def is_latest?
    klass = self.class

    !klass.where(publication_group_id: publication_group_id)
          .where(klass.arel_table[:version].gt version)
          .exists?
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
    has_write_permission?(user) || collaborators.any? do |collaborator|
      ListOwner.where(owner_id: collaborator.id, owner_type: collaborator.class.name)
        .joins(list: [:list_publication_groups, :list_readers])
        .where(
          list_publication_groups: { publication_group_id: publication_group_id },
          list_readers: { reader_id: user.id, reader_type: user.class.name }
        )
        .exists?
    end
  end

  def has_write_permission?(user)
    has_collaborator?(user) || collaborators.any? do |collaborator|
      ListOwner.where(owner_id: collaborator.id, owner_type: collaborator.class.name)
        .joins(list: :list_publication_groups)
        .joins('INNER JOIN "list_owners" "lo" ON "lo"."list_id" = "lists"."id"')
        .where(list_publication_groups: { publication_group_id: publication_group_id })
        .where(
          "\"lo\".\"owner_id\" = #{user.id} AND \"lo\".\"owner_type\" = '#{user.class.name}'"
        )
        .exists? ||
      ListOwner.where(owner_id: collaborator.id, owner_type: collaborator.class.name)
        .joins(list: [:list_publication_groups, :list_editors])
        .where(
          list_publication_groups: { publication_group_id: publication_group_id },
          list_editors: { editor_id: user.id, editor_type: user.class.name }
        )
        .exists?
    end
  end

  def publish
    self.published_at = Time.now
    self
  end

  def build_publication_group
    self.publication_group = PublicationGroup.new(publishable_type: publishable_type)
  end

  protected

  def assign_uuid_and_version
    self.uuid ||= SecureRandom.uuid
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
