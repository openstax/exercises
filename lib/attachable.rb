module Attachable
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def attachable(relation = nil)
      class_eval do
        if relation.nil?
          has_many :attachments, :as => :attachable, :dependent => :destroy
        else
          has_many :attachments, :through => relation
        end

        def get_attachment(local_name)
          attachments.where(:local_name => local_name).first
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Attachable
