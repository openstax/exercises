class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable,
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable

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

  attr_accessible :email, :password, :password_confirmation, :remember_me

  before_validation :build_user_profile, :unless => :user_profile
  before_save :force_active_admin

  validates_presence_of :username, :password, :email, :first_name, :last_name, :user_profile
  validates_uniqueness_of :username, :email

  def name
    "#{first_name} #{last_name}"
  end

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

  def self.search(text, type)
    text = text.gsub('%', '')
    return none if text.blank?

    case type
    when 'Name'
      u = scoped
      text.gsub(',', ' ').split.each do |q|
        next if q.blank?
        query = q + '%'
        u = u.where{(first_name =~ query) | (last_name =~ query)}
      end
      u
    when 'Username'
      query = text + '%'
      where{username =~ query}
    when 'Email'
      query = text + '%'  
      where{email =~ query}
    end
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
