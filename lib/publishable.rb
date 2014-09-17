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

          before_validation :build_publication, on: :create

          delegate :uid, :number, :version, :license, :attribution,
                   :is_published?, :has_collaborator?, to: :publication

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
    module Mapper
      def publishable
      end
    end
  end

  module Representable
    module Declarative
      def publishable
        class_exec do
          property :uid,
                   type: String,
                   writeable: false,
                   readable: true

          property :publication,
                   class: Publication,
                   decorator: Api::V1::PublicationRepresenter,
                   writeable: true,
                   readable: true
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Publishable::ActiveRecord
ActionDispatch::Routing::Mapper.send :include, Publishable::Routing::Mapper
Representable::Declarative.send :include, Publishable::Representable::Declarative
