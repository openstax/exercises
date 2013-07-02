class UserGroup < ActiveRecord::Base
  attr_accessible :name, :user_group_users_attributes

  accepts_nested_attributes_for :user_group_users, :allow_destroy => true

  belongs_to :container, :polymorphic => true

  has_many :user_group_users, :dependent => :destroy
  has_many :users, :through => :user_group_users

  validates_presence_of :name

  def managers
    return [] if !container.nil?
    UserGroupUser.find_all_by_user_group_id_and_is_manager(id, true)
  end

  def full_name
    container.nil? ? name : "#{container.name} #{name}"
  end
  
  def add_user(user, manager = false)
    return false if user.nil?
    ugu = UserGroupUser.new(:is_manager => (container.nil? && manager))
    ugu.user_group = self
    ugu.user = user
    return false unless ugu.save
    ugu
  end

  def remove_user(user)
    return false if user.nil?
    ugu = UserGroupUser.find_by_user_group_id_and_user_id(id, user.id)
    return false if ugu.nil?
    ugu.destroy
  end
  
  def has_user?(user)
    return false if user.nil?
    !UserGroupUser.find_by_user_group_id_and_user_id(id, user.id).nil?
  end

  def has_manager?(user)
    return false if (user.nil? || !container.nil?)
    ugu = UserGroupUser.find_by_user_group_id_and_user_id(id, user.id)
    return false if ugu.nil?
    ugu.is_manager
  end

  ##################
  # Access Control #
  ##################

  def can_be_read_by?(user)
    has_user?(user)
  end
    
  def can_be_created_by?(user)
    !user.nil?
  end
  
  def can_be_updated_by?(user)
    has_manager?(user)
  end
  
  def can_be_destroyed_by?(user)
    can_be_updated_by?(user)
  end

  protected

  #############
  # Callbacks #
  #############

  def update_callback
    user_group_users.first.update_attribute(:is_manager, true) if (container.nil? && managers.empty?)
  end

  def destroy_callback
    destroy if (container.nil? && user_group_users.empty?)
  end
end
