class User < ActiveRecord::Base

  USERNAME_FORBIDDEN_CHAR_REGEX = /[^\w-]/

  belongs_to :account,
             class_name: "OpenStax::Accounts::Account"

  delegate :username, :first_name, :last_name, :full_name, :title,
           :name, :casual_name, to: :account

  has_many :authors, dependent: :destroy, inverse_of: :user
  has_many :copyright_holders, dependent: :destroy, inverse_of: :user

  has_many :deputies, foreign_key: :deputizer_id, dependent: :destroy, inverse_of: :deputizer

  def is_human?
    true
  end
  
  def is_application?
    false
  end

  def is_anonymous?
    false
  end

  def self.anonymous
    @@anonymous ||= AnonymousUser.new
  end
end
