module Collaborable
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def collaborable
      class_eval do
        has_many :collaborators, :as => :collaborable, :dependent => :destroy

        def collaborator_for(user)
          collaborators.where(:user_id => user.id).first
        end

        def add_collaborator(user)
          return false unless collaborator_for(user).nil?

          c = Collaborator.new
          c.collaborable = self
          c.user = user

          return false unless c.save
          c
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Collaborable
