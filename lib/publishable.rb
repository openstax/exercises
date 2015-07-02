module Publishable
  module ActiveRecord
    module Base
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
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
              joins(publication: [:authors, :copyright_holders, :editors])
                .where{ (publication.published_at != nil) | \
                        (authors.user_id == user_id) | \
                        (copyright_holders.user_id == user_id) | \
                        (editors.user_id == user_id) }
            }

            scope :with_uid, ->(uid) {
              number, version = uid.to_s.split('@')
              publication_conditions = { number: number }
              publication_conditions[:version] = version unless version.nil?
              joins(:publication).where(publication: publication_conditions)
                                 .order{[publication.number.asc, publication.version.desc]}
            }

            # http://stackoverflow.com/a/7745635
            scope :latest, -> {
              class_name = name

              joins(:publication).joins{
                Publication.unscoped
                  .as(:same_number)
                  .on{ (same_number.publishable_type == my{class_name}) & \
                       (same_number.number == ~publication.number) & \
                       (same_number.version > ~publication.version) & \
                       (same_number.published_at != nil) }
                  .outer
              }.where{same_number.id == nil}
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

  module ActionDispatch
    module Routing
      module Mapper
        def publishable
          put 'publish', to: 'publications#publish'
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Publishable::ActiveRecord::Base
ActionDispatch::Routing::Mapper.send(
  :include, Publishable::ActionDispatch::Routing::Mapper
)
