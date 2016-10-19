module Publishable
  module ActiveRecord
    module Base
      def publishable(options = {})
        class_exec do

          has_one :publication, as: :publishable, dependent: :destroy, inverse_of: :publishable

          has_one :publication_group, through: :publication
          has_many :authors, through: :publication
          has_many :copyright_holders, through: :publication
          has_many :editors, through: :publication
          has_many :sources, through: :publication
          has_many :derivations, through: :publication

          delegate :uuid, :group_uuid, :number, :version, :uid, :published_at, :license,
                   :editors, :authors, :copyright_holders, :derivations,
                   :is_yanked?, :is_published?, :is_embargoed?, :is_public?,
                   :has_collaborator?, :license=, :editors=,
                   :authors=, :copyright_holders=, :derivations=,
                   to: :publication

          scope :published, -> {
            joins(:publication).where{publication.published_at != nil}
          }

          scope :unpublished, -> {
            joins(:publication).where(publication: {published_at: nil})
          }

          scope :with_id, ->(id) {
            number, version = id.to_s.split('@')

            joins(publication: :publication_group).where do
              wheres = (publication.publication_group.uuid == number) |
                       (publication.publication_group.number == number)

              case version
              when NilClass
                (wheres | (publication.uuid == number)) & (publication.published_at != nil)
              when 'draft', 'd'
                wheres & (publication.published_at == nil)
              when 'latest'
                wheres
              else
                wheres & (publication.version == version)
              end
            end.order{[publication.publication_group.number.asc, publication.version.desc]}
          }

          # The scope option determines how we limit the search for more recent versions
          # Default scope: Klass.published
          #
          # Examples:
          #
          # Klass.all.latest or Klass.all.latest(scope: Klass.published)
          # will return both the latest published versions and drafts made after them
          #
          # Klass.published.latest or Klass.published.latest(scope: Klass.published)
          # will return only the latest published versions (no drafts)
          #
          # Klass.unpublished.latest or Klass.unpublished.latest(scope: Klass.published)
          # will return only drafts made after the latest published versions
          # (could return more than 1, but the draft code makes it so there's always only 1 draft)
          #
          # Klass.all.latest(scope: Klass.all)
          # will return any drafts made after the latest published version if they exist,
          # or the latest published version if there are no drafts (but not both)
          #
          # Klass.published.latest(scope: Klass.all)
          # will return only latest published versions that don't have drafts made after them
          #
          # Klass.unpublished.latest(scope: Klass.all)
          # will return only drafts made after the latest published versions
          # (guaranteed to return only the latest draft)
          scope :latest, ->(scope: nil) {
            publishable_class_name = name
            scope ||= published

            joins(:publication).joins do
              Publication
                .unscoped
                .where(publishable_type: publishable_class_name)
                .joins do
                  scope
                    .reorder(nil).limit(nil).offset(nil)
                    .as(:newer_publishable)
                    .on{ newer_publishable.id == ~publishable_id }
                end
                .as(:newer_publication)
                .on do
                  (newer_publication.publication_group_id == ~publication.publication_group_id) &
                  (newer_publication.version > ~publication.version)
                end
                .outer
            end.where{ newer_publication.id == nil }
          }

          scope :visible_for, ->(user) {
            user = user.human_user if user.is_a?(OpenStax::Api::ApiUser)
            next published if !user.is_a?(User) || user.is_anonymous?
            next self if user.administrator
            user_id = user.id

            joins{publication.authors.outer}
              .joins{publication.copyright_holders.outer}
              .joins{publication.editors.outer}
              .where do
                (publication.published_at != nil) | \
                (authors.user_id == user_id) | \
                (copyright_holders.user_id == user_id) | \
                (editors.user_id == user_id)
              end
          }

          after_initialize :build_publication, unless: [:persisted?, :publication]
          after_create :ensure_publication!

          def before_publication
          end

          def after_publication
          end

          def ensure_publication!
            raise ::ActiveRecord::RecordInvalid, publication unless publication.persisted?
          end

        end
      end
    end
  end
end

ActiveRecord::Base.extend Publishable::ActiveRecord::Base
