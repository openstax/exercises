module Publishable
  module ActiveRecord
    module Base
      def publishable(options = {})
        class_exec do

          has_one :publication, as: :publishable, dependent: :destroy

          has_many :authors, through: :publication
          has_many :copyright_holders, through: :publication
          has_many :editors, through: :publication
          has_many :sources, through: :publication
          has_many :derivations, through: :publication

          scope :published, -> {
            joins(:publication).where{publication.published_at != nil}
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

          scope :with_uid, ->(uid) {
            number, version = uid.to_s.split('@')
            relation = joins(:publication)
            pub_conditions = { number: number }
            if version.nil?
              relation = relation.where{ publication.published_at != nil }
            elsif version == 'draft' || version == 'd'
              pub_conditions[:published_at] = nil
            else
              pub_conditions[:version] = version
            end
            relation.where(publication: pub_conditions)
                    .order{[publication.number.asc, publication.version.desc]}
          }

          # http://stackoverflow.com/a/7745635
          scope :latest, ->(publishable_scope = nil,
                            publication_scope = Publication.unscoped.published) {
            publishable_class_name = name
            publishable_scope ||= all
            joins(:publication).joins{
              publication_scope
                .reorder(nil).limit(nil).offset(nil)
                .joins{
                  publishable_scope
                    .reorder(nil).limit(nil).offset(nil)
                    .as(:newer_publishable)
                    .on{ newer_publishable.id == ~publishable_id }
                }.as(:newer_publication)
                 .on{ (newer_publication.publishable_type == publishable_class_name) &\
                      (newer_publication.number == ~publication.number) & \
                      (newer_publication.version > ~publication.version) }
                 .outer
            }.where{ newer_publication.id == nil }
          }

          after_initialize :build_publication, unless: [:persisted?, :publication]
          after_create :ensure_publication

          delegate :uid, :number, :version, :published_at, :license,
                   :editors, :authors, :copyright_holders, :derivations,
                   :is_yanked?, :is_published?, :is_embargoed?, :is_public?,
                   :has_collaborator?, :license=, :editors=,
                   :authors=, :copyright_holders=, :derivations=,
                   to: :publication

          protected

          def ensure_publication
            raise ::ActiveRecord::RecordInvalid, publication unless publication.persisted?
          end

        end
      end
    end
  end
end

ActiveRecord::Base.extend Publishable::ActiveRecord::Base