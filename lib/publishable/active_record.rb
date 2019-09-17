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
                   :license=, :authors=, :copyright_holders=, :derivations=, :nickname, :nickname=,
                   to: :publication

          scope :published,   -> do
            joins(:publication).where.not(publication: { published_at: nil })
          end

          scope :unpublished, -> { joins(:publication).where(publication: { published_at: nil }) }

          scope :with_id, ->(id) do
            nn, vv = id.to_s.split('@')

            pub = Publication.arel_table
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

            rel = joins(publication: :publication_group).where(wheres)
            rel = rel.chainable_latest if latest
            rel.order(pubg[:number].asc, pub[:version].desc)
          end

          scope :visible_for, ->(options) do
            next all if options[:can_view_solutions]

            user = options[:user]
            user = user.human_user if user.is_a?(OpenStax::Api::ApiUser)
            next published if !user.is_a?(User) || user.is_anonymous?
            next all if user.is_administrator?
            user_id = user.id

            pub = Publication.arel_table
            au = Author.arel_table
            cw = CopyrightHolder.arel_table
            dg = Delegation.arel_table
            me = arel_table

            joins(:publication).left_outer_joins(publication: [:authors, :copyright_holders]).where(
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

          validates :publication, presence: true
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

          # A publication is not valid without a number and version
          # But if we add the number and version too early they may be used by someone else
          # So we don't validate the publication and instead check if it was saved afterwards
          # Will probably have to add better error handling/retry when we have more users
          def ensure_publication!
            raise ::ActiveRecord::RecordInvalid, publication unless publication.persisted?
          end

        end
      end
    end
  end
end

ActiveRecord::Base.extend Publishable::ActiveRecord::Base
