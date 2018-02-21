module Publishable
  module ActiveRecord
    module Base
      def publishable(options = {})
        class_exec do

          has_one :publication, as: :publishable, dependent: :destroy, inverse_of: :publishable
          has_one :publication_group, through: :publication

          has_many :authors, through: :publication
          has_many :copyright_holders, through: :publication
          has_many :sources, through: :publication
          has_many :derivations, through: :publication

          delegate :uuid, :group_uuid, :number, :version, :uid, :published_at, :license,
                   :authors, :copyright_holders, :derivations, :is_yanked?, :is_published?,
                   :is_embargoed?, :is_public?, :is_chainable_latest?, :is_latest?,
                   :has_collaborator?, :has_read_permission?, :has_write_permission?,
                   :license=, :authors=, :copyright_holders=, :derivations=,
                   to: :publication

          scope :published,   -> do
            joins(:publication).where.not(publications: { published_at: nil })
          end

          scope :unpublished, -> { joins(:publication).where(publications: { published_at: nil }) }

          scope :with_id, ->(id) do
            nn, vv = id.to_s.split('@')

            joins(publication: :publication_group).where do
              wheres = (publication.publication_group.uuid == nn) |
                       (publication.publication_group.number == nn)

              case vv
              when NilClass
                (wheres | (publication.uuid == nn)) & (publication.published_at != nil)
              when 'draft', 'd'
                wheres & (publication.published_at == nil)
              when 'latest'
                wheres
              else
                wheres & (publication.version == vv)
              end
            end.order { [publication.publication_group.number.asc, publication.version.desc] }
          end

          scope :visible_for, ->(options) do
            next all if options[:can_view_solutions]

            user = options[:user]
            user = user.human_user if user.is_a?(OpenStax::Api::ApiUser)
            next published if !user.is_a?(User) || user.is_anonymous?
            next all if user.administrator
            user_id = user.id

            joins do
              [
                publication.authors,
                publication.copyright_holders,
                publication.publication_group.list_publication_groups.outer.list.outer.list_owners,
                publication.publication_group.list_publication_groups.outer.list.outer.list_editors,
                publication.publication_group.list_publication_groups.outer.list.outer.list_readers
              ].map(&:outer)
            end.where do
              (publication.published_at  != nil                                            ) |
              (authors.user_id           == user_id                                        ) |
              (copyright_holders.user_id == user_id                                        ) |
              ((list_owners.owner_id     == user_id) & (list_owners.owner_type   == 'User')) |
              ((list_editors.editor_id   == user_id) & (list_editors.editor_type == 'User')) |
              ((list_readers.reader_id   == user_id) & (list_readers.reader_type == 'User'))
            end
          end

          # By default, returns both the latest published version and the latest draft, if any
          # Chain to the published, unpublished or visible_for scopes
          scope :chainable_latest, -> do
            joins(publication: :publication_group).where(
              <<-WHERE_SQL.strip_heredoc
                "publication_groups"."latest_published_version" IS NULL
                  OR "publications"."version" >= "publication_groups"."latest_published_version"
              WHERE_SQL
            )
          end

          # Returns only the latest version (published or draft) for each PublicationGroup
          # Do not chain to published, unpublished or visible_for scopes
          scope :latest, -> do
            joins(publication: :publication_group).where(
              <<-WHERE_SQL.strip_heredoc
                "publication_groups"."latest_version" IS NULL
                  OR "publications"."version" = "publication_groups"."latest_version"
              WHERE_SQL
            )
          end

          after_initialize :build_publication, if: :new_record?, unless: :publication
          after_create :ensure_publication!

          # Retrieves all versions of this publishable visible for the given user
          def visible_versions(can_view_solutions:)
            publication.publication_group
                       .publications
                       .visible_for(can_view_solutions: can_view_solutions)
                       .pluck(:version)
          end

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
