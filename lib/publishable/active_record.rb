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

          # http://stackoverflow.com/a/7745635
          scope :latest, ->(scope: nil, published: true) {
            publishable_class_name = name
            scope ||= all
            publication_scope = Publication.unscoped
            publication_scope = publication_scope.published if published

            joins(:publication).joins{
              publication_scope
                .joins{
                  scope
                    .reorder(nil).limit(nil).offset(nil)
                    .as(:newer_publishable)
                    .on{ newer_publishable.id == ~publishable_id }
                }.as(:newer_publication)
                 .on{ (newer_publication.publication_group_id == publication_group_id) &
                      (newer_publication.version > ~publication.version) }
                 .outer
            }.where{ newer_publication.id == nil }
          }

          scope :visible_for, ->(user) {
            user = user.human_user if user.is_a?(OpenStax::Api::ApiUser)
            next published if !user.is_a?(User) || user.is_anonymous?
            next self if user.administrator
            user_id = user.id

            joins{publication.authors.outer}
              .joins{publication.copyright_holders.outer}
              .joins{publication.editors.outer}
              .where{ (publication.published_at != nil) | \
                      (authors.user_id == user_id) | \
                      (copyright_holders.user_id == user_id) | \
                      (editors.user_id == user_id) }
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
