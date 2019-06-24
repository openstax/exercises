class User < ApplicationRecord

  USERNAME_FORBIDDEN_CHAR_REGEX = /[^\w-]/

  acts_as_voter

  belongs_to :account, class_name: "OpenStax::Accounts::Account", autosave: true

  has_many :groups_as_member, through: :account
  has_many :groups_as_owner, through: :account

  has_one :administrator, dependent: :destroy

  has_many :authors, dependent: :destroy
  has_many :copyright_holders, dependent: :destroy

  has_many :delegations_as_delegator, class_name: 'Delegation',
                                      foreign_key: :delegator_id,
                                      dependent: :destroy,
                                      inverse_of: :delegator
  has_many :delegations_as_delegate, class_name: 'Delegation',
                                     as: :delegate,
                                     dependent: :destroy

  has_many_through_groups :groups_as_member, :list_owners, as: :owner, dependent: :destroy
  has_many_through_groups :groups_as_member, :list_editors, as: :editor, dependent: :destroy
  has_many_through_groups :groups_as_member, :list_readers, as: :reader, dependent: :destroy

  has_many_through_groups :groups_as_member, :applications, class_name: 'Doorkeeper::Application',
                                                            as: :owner,
                                                            dependent: :destroy

  has_many :sortings, dependent: :destroy

  validates :account, uniqueness: true

  delegate :username, :first_name, :last_name, :full_name, :title,
           :name, :casual_name, :first_name=, :last_name=, :full_name=,
           :title=, :faculty_status, :role, :uuid, :support_identifier, to: :account

  def self.anonymous
    AnonymousUser.instance
  end

  def default_authors
    [ self ] + delegations_as_delegate.to_a.select(&:can_assign_authorship).map(&:delegator)
  end

  def default_copyright_holders
    [ self ] + delegations_as_delegate.to_a.select(&:can_assign_copyright).map(&:delegator)
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

  def is_administrator?
    !administrator.nil?
  end

  def is_deleted?
    !deleted_at.nil?
  end

  def destroy
    update_attribute(:deleted_at, Time.now)
  end

  def delete
    update_column(:deleted_at, Time.now)
  end

  def undelete
    update_column(:deleted_at, nil)
  end

end
