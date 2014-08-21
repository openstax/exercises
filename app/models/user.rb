class User < ActiveRecord::Base

  USERNAME_DISCARDED_CHAR_REGEX = /[^A-Za-z\d_]/

  belongs_to :openstax_accounts_user,
             class_name: "OpenStax::Accounts::User",
             dependent: :destroy

  delegate :username, :first_name, :last_name, :name, :casual_name,
           to: :openstax_accounts_user

  has_many :collaborators, :dependent => :destroy, :inverse_of => :user

  has_many :user_group_users, :dependent => :destroy, :inverse_of => :user
  has_many :user_groups, :through => :user_group_users

  has_one :deputy_user_group, :class_name => 'UserGroup',
                              :as => 'container', :dependent => :destroy
  has_many :deputies, :through => :deputy_user_group, :source => :users
  has_many :deputizers, :through => :user_groups, :class_name => 'User',
           :source => :container, :source_type => 'User'

  belongs_to :default_list, :class_name => 'List'
  has_many :lists, :through => :user_groups,
                   :source => :container, :source_type => 'List'
  has_many :listed_exercises, :through => :lists, :source => :exercises

  before_save :force_first_admin

  validates_presence_of :default_list

  scope :registered, where(is_registered: true)
  scope :unregistered, where{is_registered != true}

  def is_disabled?
    !disabled_at.nil?
  end

  def disable
    update_attribute(:disabled_at, Time.now)
  end

  def editable_lists
    lists.select{|l| l.can_be_edited_by?(self)}
  end

  def owned_lists
    lists.select{|l| l.can_be_updated_by?(self)}
  end

  def is_human?
    true
  end
  
  def is_application?
    false
  end

  #
  # Anonymous User stuff
  #

  attr_accessor :is_anonymous

  def is_anonymous?
    is_anonymous
  end

  def self.anonymous
    @@anonymous ||= AnonymousUser.new
  end

  class AnonymousUser < User
    before_save { false } 
    def initialize(attributes=nil)
      super
      self.is_anonymous          = true
      self.is_registered         = false
      self.openstax_accounts_user = OpenStax::Accounts::User.anonymous
    end
  end

  protected

  #############
  # Callbacks #
  #############

  def force_first_admin
    if self == User.first
      self.is_admin = true
      self.disabled_at = nil
    end
  end
end
