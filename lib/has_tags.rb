module HasTags
  module ActiveRecord
    module Associations
      class TagCollectionProxy < ::ActiveRecord::Associations::CollectionProxy
        def initialize(taggings, tagged, inverse_association_name)
          @tagged = tagged
          @inverse_association_name = inverse_association_name
          super(taggings.klass, taggings.proxy_association)
        end

        def load_target
          super.collect{|t| t.tag.name}
        end

        def <<(tag_name)
          tagging = model.new(
            @inverse_association_name => @tagged,
            tag: Tag.find_or_initialize_by(name: tag_name.to_s.downcase)
          )

          super(tagging)
        end
      end
    end

    module Base
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        def has_tags(association_name = nil, options = {})
          association_name ||= "#{name.tableize.singularize}_tags"
          inverse_association_name = options[:inverse_of] || \
                                     name.tableize.singularize
          tagging_class = association_name.to_s.classify.constantize

          class_exec do
            has_many association_name.to_sym,
                     { dependent: :destroy, autosave: true }.merge(options)

            define_method(:tags) do
              HasTags::ActiveRecord::Associations::TagCollectionProxy.new(
                send(association_name), self, inverse_association_name
              )
            end

            define_method(:tags=) do |tag_names|
              taggings = send(association_name).to_a

              tag_names.each_with_index do |tag_name, i|
                taggings[i] ||= tagging_class.new(
                  inverse_association_name => self
                )
                taggings[i].tag = Tag.find_or_initialize_by(
                                    name: tag_name.to_s.downcase
                                  )
              end

              send("#{association_name}=", taggings[0..tag_names.length-1])
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
