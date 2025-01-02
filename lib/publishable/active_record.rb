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
                   :authors, :copyright_holders, :delegations, :derivations, :is_yanked?,
                   :is_published?, :is_embargoed?, :is_public?, :is_chainable_latest?, :is_latest?,
                   :has_collaborator?, :has_read_permission?, :has_write_permission?,
                   :license=, :authors=, :copyright_holders=, :derivations=, :nickname, :nickname=,
                   :solutions_are_public, :solutions_are_public=, to: :publication

          scope :published,   -> do
            joins(:publication).where.not(publication: { published_at: nil })
          end

          scope :unpublished, -> { joins(:publication).where(publication: { published_at: nil }) }

          scope :with_id, ->(id) do
            number_or_uuid, version = id.to_s.split('@')
            number = Integer(number_or_uuid) rescue nil

            join_rel = joins(publication: :publication_group)
            or_rel = join_rel.where(publication_group: { uuid: number_or_uuid })
            or_rel = or_rel.or(join_rel.where(publication_group: { number: number })) \
              unless number.nil?

            rel = case version
            when NilClass
              join_rel.where(publication: { uuid: number_or_uuid }).or(
                or_rel.where.not(publication: { published_at: nil })
              )
            when 'draft', 'd'
              or_rel.unpublished
            when 'latest'
              or_rel.chainable_latest
            else
              or_rel.where(publication: { version: version })
            end

            rel.order('"publication_group"."number" ASC').order('"publication"."version" DESC')
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

            rel = joins(:publication).left_outer_joins(publication: [:authors, :copyright_holders])
            rel = rel.where.not(publication: { published_at: nil }).or(
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
            joins(publication: :publication_group).where.not(
              publication: { id: nil }, publication_group: { id: nil } # Rails 6.1 workaround
            ).where(
              <<-WHERE_SQL.strip_heredoc
                "publication_group"."latest_published_version" IS NULL
                  OR "publication"."version" >= "publication_group"."latest_published_version"
              WHERE_SQL
            )
          end

          # Returns only the latest version (published or draft) for each PublicationGroup
          # Do not chain to published, unpublished or visible_for scopes
          scope :latest, -> do
            joins(publication: :publication_group).where.not(
              publication: { id: nil }, publication_group: { id: nil } # Rails 6.1 workaround
            ).where(
              <<-WHERE_SQL.strip_heredoc
                "publication_group"."latest_version" IS NULL
                  OR "publication"."version" = "publication_group"."latest_version"
              WHERE_SQL
            )
          end

          after_initialize :build_publication, if: :new_record?, unless: :publication

          validates :publication, presence: true
          after_create :ensure_publication!

          # Retrieves all versions of this publishable visible for the given user
          def visible_versions(can_view_solutions:)
            publications = publication.publication_group.publications.to_a
            publications = publications.select(&:is_published?) unless can_view_solutions
            publications.map(&:version)
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
