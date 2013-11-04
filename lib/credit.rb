require 'credit_migration'

module Credit
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def credit
      class_eval do
        attr_accessible :credit
      end
    end
  end
end

ActiveRecord::Base.send :include, Credit
