class User < ActiveRecord::Base
  belongs_to :openstax_connect_user, 
             class_name: "OpenStax::Connect::User",
             dependent: :destroy

  delegate :username, :first_name, :last_name, :name, :casual_name,
           to: :openstax_connect_user

  has_one :user_profile, :dependent => :destroy, :inverse_of => :user

  has_one :default_list, :through => :user_profile

  has_one :deputy_user_group, :through => :user_profile
  has_many :deputies, :through => :user_profile

  has_many :collaborators, :dependent => :destroy, :inverse_of => :user

  has_many :user_group_users, :dependent => :destroy, :inverse_of => :user
  has_many :user_groups, :through => :user_group_users

  has_many :deputizer_profiles, :through => :user_groups, :source => :container, :source_type => 'UserProfile'
  has_many :deputizers, :through => :deputizer_profiles, :source => :user

  has_many :lists, :through => :user_groups, :source => :container, :source_type => 'List'
  has_many :listed_exercises, :through => :lists, :source => :exercises

  before_validation :build_user_profile, :unless => :user_profile
  before_save :force_active_admin

  validates_presence_of :user_profile

  scope :registered, where(is_registered: true)
  scope :unregistered, where{is_registered != true}

  def is_admin?
    is_admin
  end

  def is_disabled?
    !disabled_at.nil?
  end

  def disable
    update_attribute(:disabled_at, Time.now)
  end

  def ensure_default_list
    user_profile.ensure_default_list
  end

  def editable_lists
    lists.select{|l| l.can_be_edited_by?(self)}
  end

  def owned_lists
    lists.select{|l| l.can_be_updated_by?(self)}
  end

  def is_registered?
    is_registered == true
  end

  def is_anonymous?
    is_anonymous == true
  end

  #
  # Anonymous User stuff
  #

  attr_accessor :is_anonymous

  def self.anonymous
    @@anonymous ||= AnonymousUser.new
  end

  class AnonymousUser < User
    before_save { false } 
    def initialize(attributes=nil)
      super
      self.is_anonymous          = true
      self.is_registered         = false
      self.openstax_connect_user = OpenStax::Connect::User.anonymous
    end
  end

  #
  # OpenStax Connect "user_provider" methods
  #

  def self.connect_user_to_app_user(connect_user)
    GetOrCreateUserFromConnectUser.call(connect_user).outputs.user
  end

  def self.app_user_to_connect_user(app_user)
    app_user.is_anonymous? ? OpenStax::Connect::User.anonymous : app_user.openstax_connect_user
  end

  ##################
  # Access Control #
  ##################

  def can_be_updated_by?(user)
    !user.nil? && user.is_admin?
  end

  def can_be_destroyed_by?(user)
    can_be_updated_by?(user)
  end

  protected

  #############
  # Callbacks #
  #############

  def build_user_profile
    self.user_profile = UserProfile.new
    user_profile.user = self
  end

  def force_active_admin
    if self == User.first
      self.is_admin = true
      self.disabled_at = nil
    end
  end
end
