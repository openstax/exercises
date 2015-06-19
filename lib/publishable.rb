module Publishable
  module ActiveRecord
    module Base
      ID_REGEX = /\A(\d+)(@(\d+))?\z/

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

            scope :published, lambda {
              joins(:publication).includes(:publication).where{publication.published_at != nil}
            }

            scope :visible_for, lambda { |user|
              user = user.human_user if user.is_a?(OpenStax::Api::ApiUser)
              next published if !user.is_a?(User) || user.is_anonymous?
              next joins(:publication).includes(:publication) if user.administrator
              user_id = user.id
              joins(:publication)
                .includes(publication: [:authors, :copyright_holders, :editors])
                .references(publication: [:authors, :copyright_holders, :editors])
                .where{(publication.published_at != nil) | \
                       (authors.user_id == user_id) | \
                       (copyright_holders.user_id == user_id) | \
                       (editors.user_id == user_id)}
            }

            after_initialize :build_publication, unless: [:persisted?, :publication]
            after_create :ensure_publication

            delegate :uid, :number, :version, :published_at, :license,
                     :editors, :authors, :copyright_holders, :derivations,
                     :is_yanked?, :is_published?, :is_embargoed?, :is_public?,
                     :has_collaborator?, :license=, :editors=,
                     :authors=, :copyright_holders=, :derivations=,
                     to: :publication

            def self.find(*args)
              return super if block_given? || args.size != 1
              id = args.first
              return super unless id.is_a?(String) && \
              Publishable::ActiveRecord::Base::ID_REGEX =~ id
              Publication.find_by(publishable_type: name, number: $1, version: $3)
                         .try(:publishable) || super
            end

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
