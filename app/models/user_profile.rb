class UserProfile < ActiveRecord::Base
  attr_accessible :announcement_email, :auto_author_subscribe,
                  :collaborator_request_email, :user_group_member_email

  belongs_to :user
  belongs_to :default_list, :class_name => 'List'

  has_one :deputy_user_group, :class_name => 'UserGroup', :as => 'container', :dependent => :destroy

  validates_presence_of :user, :default_list
  validates_uniqueness_of :user_id

  before_validation :create_default_list, :unless => :default_list
  after_create :create_deputy_user_group

  protected

  def create_deputy_user_group
    dug = UserGroup.new(:name => "deputies")
    dug.container = self
    dug.save
  end

  public

  def name
    user.name
  end

  def create_default_list
    dl = List.create!(:name => "#{name}'s default list")
    dl.add_permission(user, :manager)
    self.default_list = dl
    self.default_list_id = dl.id
  end

  ##########################
  # Access control methods #
  ##########################

  def can_be_read_by?(user)
    user == self.user
  end
  
  def can_be_updated_by?(user)
    user == self.user
  end
end
