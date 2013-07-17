module Publishable
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def publishable(scope_symbols = nil)
      class_name = self.class.name.undercase
      derived_names = "derived_#{class_name.pluralize}"
      source_name = "source_#{class_name}"
      source_name_id = "#{source_name}_id"

      class_eval do
        belongs_to source_name, :class_name => class_name, :inverse_of => derived_names

        has_many derived_names, :class_name => class_name, :foreign_key => source_name_id, :inverse_of => source_name

        has_many :collaborators, :as => :publishable, :dependent => :destroy

        before_validation :assign_next_number, :unless => :number
        before_update :must_not_be_published

        validates_presence_of :number, :version
        validates_presence_of :license, :if => :is_published?
        validates_uniqueness_of :version, :scope => ((publish_scope_array || []) << :number)

        default_scope order("number ASC", "version DESC")

        def publish
          return if !run_prepublish_checks

          collaborators.roleless.all.each { |rc| rc.destroy }
          
          self.published_at = Time.now
          self.save
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

        def has_license?
          !license.nil?
        end

        def has_collaborator?(user)
          return false if user.nil?
          !collaborators.where(:user_id => user.id).first.nil?
        end

        def add_collaborator(user)
          return false if has_collaborator?(user)

          c = Collaborator.new
          c.collaborable = self
          c.user = user
          c.save!
          c
        end

        def self.add_prepublish_check(method_name, value, error_message)
          prepublish_checks << [method_name, value, error_message]
        end

        def assign_next_number
          self.number = ((publish_scope.maximum(:number) || -1) + 1)
        end

        protected

        cattr_accessor :dup_includes_array, :prepublish_checks_array, :publish_scope_array

        dup_includes_array = []

        prepublish_checks_array = [[:is_published?, false, "This #{class_name} is already published."],
          [:has_license?, true, "A license has not yet been specified for this #{class_name}."],
          [:has_all_roles?, true, "The author or copyright holder roles are not filled for this #{class_name}."],
          [:has_collaborator_requests?, false, "This #{class_name} has pending role requests."]]

        publish_scope_array = scope_symbols.nil? ? nil : \
          (scope_symbols.is_a?(Array) ? scope_symbols : [scope_symbols])

        def publish_scope
          publish_scope_array.nil? ? self.class.scoped : self.class.where(Hash[publish_scope_array.map{|s| [s, send(s)]}])
        end

        def must_not_be_published
          return if published_at_was.nil?
          errors.add(:base, "Changes cannot be made to a published #{self.class.name.undercase}.")
          false
        end

        def has_collaborator_requests?
          !collaborators.where(:toggle_author_request => true).first.nil? || \
            !collaborators.where(:toggle_copyright_holder_request => true).first.nil?
        end

        def has_all_roles?
          !collaborators.where(:is_author => true).first.nil? && \
            !collaborators.where(:is_copyright_holder => true).first.nil?
        end

        def run_prepublish_checks
          prepublish_checks_array.each do |pc|
            self.errors.add(:base, pc.third) unless send(pc.first) == pc.second
          end

          errors.empty?
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Publishable
