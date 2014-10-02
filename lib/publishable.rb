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
