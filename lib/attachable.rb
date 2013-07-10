module Attachable
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def attachable(relation = nil)
      class_eval do
        cattr_accessible :attachable_relation
        attachable_relation = relation

        has_many :attachments, :as => :attachable, :dependent => :destroy unless relation

        def get_attachment(local_name)
          attachable_relation.nil? ? \
            attachments.where(:local_name => local_name).first : \
            send(attachable_relation).get_attachment(local_name)
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Attachable
