class UserGroup < ActiveRecord::Base
  attr_accessible :name, :user_group_members_attributes

  has_many :user_group_members, :dependent => :destroy
  has_many :users, :through => :user_group_members
  
  accepts_nested_attributes_for :user_group_members, :allow_destroy => true

  validates_presence_of :name

  def managers
    user_group_members.select{ |ugm| ugm.is_manager }
  end
  
  def add_user!(user)
    UserGroupMember.create(:user_group => self, :user => user)
  end
  
  def is_member?(user)
    return false if user.nil?
    users.include?(user)
  end

  def is_manager?(user)
    return false if user.nil?
    user_group_member = UserGroupMember.find_by_user_group_id_and_user_id(id, user.id)
    return false if user_group_member.nil?
    user_group_member.is_manager
  end

  def update_callback
    user_group_members.first.update_attribute(:is_manager, true) if managers.empty?
  end

  def destroy_callback
    destroy if user_group_members.empty?
  end
  
  ##########################
  # Access control methods #
  ##########################

  def can_be_read_by?(user)
    is_member?(user)
  end
    
  def can_be_created_by?(user)
    !user.nil?
  end
  
  def can_be_updated_by?(user)
    is_manager?(user)
  end
  
  def can_be_destroyed_by?(user)
    can_be_updated_by?(user)
  end
end
