class User < ActiveRecord::Base

  USERNAME_FORBIDDEN_CHAR_REGEX = /[^\w-]/

  belongs_to :account, class_name: "OpenStax::Accounts::Account"

  delegate :username, :first_name, :last_name, :full_name, :title,
           :name, :casual_name, to: :account

  has_one :administrator, inverse_of: :user

  has_many :collaborators, dependent: :destroy, inverse_of: :user
  has_many :author_requests, through: :collaborators
  has_many :copyright_holder_requests, through: :collaborators

  has_many :sent_author_requests, class_name: 'AuthorRequest',
           foreign_key: :requestor_id, dependent: :destroy, inverse_of: :requestor
  has_many :sent_copyright_holder_requests, class_name: 'CopyrightHolderRequest',
           foreign_key: :requestor_id, dependent: :destroy, inverse_of: :requestor

  has_many :child_deputizations, foreign_key: :deputizer_id,
           dependent: :destroy, inverse_of: :deputizer
  has_many :direct_parent_deputizations, class_name: 'Deputization',
           as: :deputy, dependent: :destroy
  has_many :indirect_parent_deputizations, through: :groups, source: :deputizations

  validates :account, presence: true, uniqueness: true

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
