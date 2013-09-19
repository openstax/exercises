module Publishable
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def publishable(scope_symbols = nil)
      class_name = self.name.downcase
      class_name_plural = class_name.pluralize
      derived_names = "derived_#{class_name_plural}"
      source_names = "source_#{class_name_plural}"

      class_eval do
        cattr_accessor :dup_includes_array
        self.dup_includes_array = []

        cattr_accessor :prepublish_checks_array
        self.prepublish_checks_array = [[:is_published?, false, "This #{class_name} is already published."],
          [:has_all_roles?, true, "The author or copyright holder roles are not filled for this #{class_name}."],
          [:has_roleless_collaborators?, false, "This #{class_name} has collaborators with no roles."],
          [:has_collaborator_requests?, false, "This #{class_name} has pending role requests."]]

        cattr_accessor :publish_scope_array
        self.publish_scope_array = scope_symbols.nil? ? nil : \
          (scope_symbols.is_a?(Array) ? scope_symbols : [scope_symbols])

        belongs_to :license, :inverse_of => class_name_plural.to_sym

        has_many :sources, :class_name => 'Derivation', :as => :publishable, :foreign_key => 'derived_publishable_id', :dependent => :destroy
        has_many source_names, :through => :sources, :source => :source_publishable, :source_type => class_name

        has_many :derivations, :as => :publishable, :foreign_key => 'source_publishable_id', :dependent => :destroy
        has_many derived_names, :through => :derivations, :source => :derived_publishable, :source_type => class_name

        has_many :collaborators, :as => :publishable, :dependent => :destroy

        attr_accessible :license_id

        before_validation :assign_next_number, :unless => :number

        validates_presence_of :number, :version, :license
        validates_uniqueness_of :version, :scope => ((publish_scope_array || []) << :number)
        validate :valid_license

        default_scope order("number ASC", "version DESC")

        def publish!
          self.published_at = Time.now
          
          save!
        end

        def new_version
          version_scope = publish_scope.where(:number => number)
          latest = version_scope.first
          return latest unless latest.is_published?

          new_copy = latest.dup(:include => (dup_includes_array << :collaborators), :use_dictionary => true)

          new_copy.version += 1
          new_copy.save!
          new_copy
        end

        def derive_for(user)
          derived_copy = dup(:include => dup_includes_array, :use_dictionary => true)

          derived_copy.assign_next_number
          derived_copy.version = 1

          derived_copy.transaction do
            derived_copy.save!

            c = derived_copy.add_collaborator(user)
            c.is_author = true
            c.is_copyright_holder = true
            c.save!
          end

          derived_copy
        end

        def is_published?
          !published_at.nil?
        end

        def has_collaborator?(user)
          return false if user.nil?
          !collaborators.where(:user_id => user.id).first.nil?
        end

        def add_collaborator(user)
          c = Collaborator.new
          c.publishable = self
          c.user = user
          c.save!
          c
        end

        def add_default_collaborator(user)
          c = Collaborator.new
          c.publishable = self
          c.user = user
          c.is_author = true
          c.is_copyright_holder = true
          c.save!
          c
        end

        def add_source(publishable)
          return false if publishable.class != self.class
          Derivation.create!(:source_publishable => publishable, :derived_publishable => self)
        end

        def assign_next_number
          self.number = ((publish_scope.maximum(:number) || 0) + 1)
        end

        def can_be_published_by?(user)
          published_at.nil? && can_be_updated_by?(user)
        end

        def run_prepublish_checks
          prepublish_checks_array.each do |pc|
            self.errors.add(:base, pc.third) unless send(pc.first) == pc.second
          end

          errors.empty?
        end

        def self.add_prepublish_check(method_name, value, error_message)
          prepublish_checks_array << [method_name, value, error_message]
        end

        protected

        def publish_scope
          publish_scope_array.nil? ? self.class.scoped : self.class.where(Hash[publish_scope_array.map{|s| [s, send(s)]}])
        end

        def has_all_roles?
          !collaborators.where(:is_author => true).first.nil? && \
            !collaborators.where(:is_copyright_holder => true).first.nil?
        end

        def has_roleless_collaborators?
          !collaborators.roleless.first.nil?
        end

        def has_collaborator_requests?
          !collaborators.where(:toggle_author_request => true).first.nil? || \
            !collaborators.where(:toggle_copyright_holder_request => true).first.nil?
        end

        def valid_license
          return if license.valid_for?(self)
          errors.add(:license_id, "specified cannot be used for #{self.class.name.downcase.pluralize}.")
          false
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Publishable
