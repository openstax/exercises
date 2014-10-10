module Publishable
  module ActiveRecord

    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def publishable(options = {})
        first_letter = name.first.downcase
        regex = Regexp.new "\\A#{name.first.downcase}(\\d+)(v(\\d+)|d)?\\z"

        class_exec do

          cattr_accessor :id_regex
          self.id_regex = regex

          has_one :publication, as: :publishable, dependent: :destroy

          has_many :authors, through: :publication
          has_many :copyright_holders, through: :publication
          has_many :editors, through: :publication
          has_many :sources, through: :publication
          has_many :derivations, through: :publication

          scope :published, lambda { joins(:publication).includes(:publication)
                                       .where{publication.published_at != nil} }

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

          before_validation :build_publication, on: :create, unless: :publication

          delegate :uid, :number, :version, :published_at, :license, :editors,
                   :authors, :copyright_holders, :derivations, :is_published?,
                   :has_collaborator?, :license=, :editors=, :authors=,
                   :copyright_holders=, :derivations=, to: :publication

          def self.find(*args)
            return super if block_given? || args.size != 1
            id = args.first
            return super unless id.is_a?(String) && id_regex =~ id
            Publication.for(name, $1, $3).first.try(:publishable) || super
          end

        end
      end
    end
  end

  module Routing
    def publishable
      resource :publication, only: [:show]

      post 'publish', to: 'publications#publish'
    end
  end
end

ActiveRecord::Base.send :include, Publishable::ActiveRecord
ActionDispatch::Routing::Mapper.send :include, Publishable::Routing
