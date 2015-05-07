module HasTags
  module ActiveRecord
    module Base
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def has_tags(association_name = nil, options = {})
          association_name ||= "#{name.tableize.singularize}_tags"
          inverse_association_name = options[:inverse_of] || name.tableize.singularize
          tagging_class = association_name.to_s.classify.constantize

          class_exec do
            has_many association_name.to_sym, { dependent: :destroy, autosave: true }.merge(options)
            has_many :tags, through: association_name.to_sym do
              def <<(tag)
                super(Tag.get(tag))
              end
            end

            def tags=(tags)
              super(Tag.get(tags))
            end
          end
        end
      end
    end
  end

  module Roar
    module Decorator
      def has_tags
        collection :tags,
                   writeable: true,
                   readable: true,
                   schema_info: {
                     items: {
                       type: "string"
                     }
                   }
      end
    end
  end
end

ActiveRecord::Base.send :include, HasTags::ActiveRecord::Base
Roar::Decorator.extend HasTags::Roar::Decorator
