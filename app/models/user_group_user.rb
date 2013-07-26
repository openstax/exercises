class UserGroupUser < ActiveRecord::Base
  sortable :user_id

  belongs_to :user_group, :inverse_of => :user_group_users
  belongs_to :user, :inverse_of => :user_group_users

  attr_accessible :is_manager

  after_update :user_group_checks
  after_destroy :user_group_checks

  validates_presence_of :user, :user_group
  validates_uniqueness_of :user_id, :scope => :user_group_id

  scope :managers, where(:is_manager => true)

  ##################
  # Access Control #
  ##################

  def can_be_created_by?(user)
    user_group.can_be_updated_by?(user)
  end

  def can_be_updated_by?(user)
    can_be_created_by?(user)
  end
  
  def can_be_destroyed_by?(user)
    can_be_created_by?(user) || user == self.user
  end

  protected

  #############
  # Callbacks #
  #############

  def user_group_checks
    user_group.destroy_empty_or_force_manager
  end
end
