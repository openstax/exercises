class UserProfile < ActiveRecord::Base
  belongs_to :user, :inverse_of => :user_profile

  belongs_to :default_list, :class_name => 'List'

  has_one :deputy_user_group, :class_name => 'UserGroup', :as => 'container', :dependent => :destroy
  has_many :deputies, :through => :deputy_user_group, :source => :users

  attr_accessible :announcement_email, :auto_author_subscribe,
                  :collaborator_request_email, :user_group_member_email

  before_validation :create_default_list, :unless => :default_list
  after_create :create_deputy_user_group

  validates_presence_of :user, :default_list
  validates_uniqueness_of :user_id

  def name
    user.name
  end

  ##################
  # Access Control #
  ##################

  def can_be_read_by?(user)
    user == self.user
  end
  
  def can_be_updated_by?(user)
    user == self.user
  end

  protected

  #############
  # Callbacks #
  #############

  def create_default_list
    dl = List.create!(:name => "#{name}'s default list")
    dl.add_permission(user, :owner)
    self.default_list = dl
    self.default_list_id = dl.id
  end

  def create_deputy_user_group
    dug = UserGroup.new(:name => "Deputies")
    dug.container = self
    dug.save!
  end
end
