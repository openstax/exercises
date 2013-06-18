class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, 
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :last_name, :first_name
  # attr_accessible :title, :body

  before_create :make_first_user_an_admin
  before_update :validate_at_least_one_admin

  def self.administrators; where{is_administrator == true}; end

  def is_administrator?
    is_administrator
  end

  def make_first_user_an_admin
    if User.count == 0
      self.is_administrator = true
    end
  end

  def validate_username_unchanged
    return if username == username_was
    errors.add(:base, "Usernames cannot be changed.")
    false
  end

  def validate_at_least_one_admin
    only_one_active_admin = User.administrators.count == 1
    was_admin = is_administrator_was
    return if !only_one_active_admin ||
              !was_admin ||
              (is_administrator?)
    errors.add(:base, "There must have at least one admin.")
    false
  end

  # Access control redirect methods
  
  def can_read?(resource)
    resource.can_be_read_by?(self)
  end
  
  def can_create?(resource)
    resource.can_be_created_by?(self)
  end
  
  def can_update?(resource)
    resource.can_be_updated_by?(self)
  end
    
  def can_destroy?(resource)
    resource.can_be_destroyed_by?(self)
  end
  
end
