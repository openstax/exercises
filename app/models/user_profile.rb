class UserProfile < ActiveRecord::Base
  attr_accessible :announcement_email, :auto_author_subscribe,
                  :collaborator_request_email, :user_group_member_email

  belongs_to :user
  belongs_to :deputy_user_group, :class_name => 'UserGroup', :dependent => :destroy
  belongs_to :default_list, :class_name => 'List'

  validates_uniqueness_of :user_id

  after_create :create_deputy_user_group
  after_create :create_default_list

  protected

  def create_deputy_user_group
    self.deputy_user_group = UserGroup.new(:name => "deputies")
    self.deputy_user_group.parent_object = self
    self.deputy_user_group.save
    self.save
  end

  def create_default_list
    self.default_list = List.new(:name => "#{name}'s default list")
    self.default_list.save
    self.default_list.add_permission(user, :manager)
    self.save
  end

  public

  def name
    user.name
  end

  ##########################
  # Access control methods #
  ##########################

  def can_be_read_by?(user)
    !user.nil? && user == self.user
  end
  
  def can_be_updated_by?(user)
    !user.nil? && user == self.user
  end
end
