class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable,
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  before_create :make_first_user_an_admin
  before_update :validate_username_unchanged, :validate_at_least_one_admin

  scope :admins, where(:is_admin => true)

  def is_admin?
    is_admin
  end

  def is_disabled?
    !disabled_at.nil?
  end

  protected

  def make_first_user_an_admin
    self.is_admin = true if User.count == 0
  end

  def validate_username_unchanged
    return if username == username_was
    errors.add(:base, "Usernames cannot be changed.")
    false
  end

  def validate_at_least_one_admin
    return if (User.admins.count != 1) ||
              !is_admin_was || is_admin
    errors.add(:base, "There must be at least one admin.")
    false
  end
end
