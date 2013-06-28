class UserGroupMember < ActiveRecord::Base
  attr_accessible :is_manager

  belongs_to :user
  belongs_to :user_group

  validates_presence_of :user, :user_group
  validates_uniqueness_of :user_id, :scope => :user_group_id

  after_update :update_callback
  after_destroy :destroy_callback

  def update_callback
    user_group.update_callback
  end

  def destroy_callback
    user_group.destroy_callback
  end
  
  ##########################
  # Access control methods #
  ##########################

  def can_be_created_by?(user)
    user_group.can_be_updated_by?(user)
  end

  def can_be_updated_by?(user)
    user_group.can_be_updated_by?(user)
  end
  
  def can_be_destroyed_by?(user)
    can_be_updated_by?(user) || user == self.user
  end
end
