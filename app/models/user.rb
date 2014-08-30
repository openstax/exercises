class User < ActiveRecord::Base

  USERNAME_FORBIDDEN_CHAR_REGEX = /[^\w-]/

  acts_as_voter

  belongs_to :account, class_name: "OpenStax::Accounts::Account"
  has_many :groups_as_member, through: :account
  has_many :groups_as_owner, through: :account

  has_one :administrator, dependent: :destroy, inverse_of: :user

  has_many :collaborators, dependent: :destroy, inverse_of: :user
  has_many :author_requests, through: :collaborators
  has_many :copyright_holder_requests, through: :collaborators

  has_many :sent_author_requests, class_name: 'AuthorRequest',
           foreign_key: :requestor_id, dependent: :destroy, inverse_of: :requestor
  has_many :sent_copyright_holder_requests, class_name: 'CopyrightHolderRequest',
           foreign_key: :requestor_id, dependent: :destroy, inverse_of: :requestor

  has_many :child_deputizations, class_name: 'Deputization',
           foreign_key: :deputizer_id, dependent: :destroy, inverse_of: :deputizer
  has_many_through_groups :groups_as_member, :deputizations,
                          as: :deputy, dependent: :destroy

  has_many_through_groups :groups_as_member, :list_owners,
                          as: :owner, dependent: :destroy
  has_many_through_groups :groups_as_member, :list_editors,
                          as: :editor, dependent: :destroy
  has_many_through_groups :groups_as_member, :list_readers,
                          as: :reader, dependent: :destroy

  has_many :applications, class_name: 'Doorkeeper::Application',
           as: :owner, dependent: :destroy

  validates :account, presence: true, uniqueness: true

  delegate :username, :first_name, :last_name, :full_name, :title,
           :name, :casual_name, to: :account

  def self.anonymous
    AnonymousUser.instance
  end

  def is_human?
    true
  end
  
  def is_application?
    false
  end

  def is_anonymous?
    false
  end

end
