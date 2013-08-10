class Collaborator < ActiveRecord::Base
  sortable [:publishable_type, :publishable_id]

  belongs_to :publishable, :polymorphic => true

  belongs_to :user, :inverse_of => :collaborators
  has_many :deputies, :through => :user

  attr_accessible :toggle_author_request, :toggle_copyright_holder_request

  validates_presence_of :user, :publishable
  validates_uniqueness_of :user_id, :scope => [:publishable_type, :publishable_id]

  scope :roleless, where({:is_author => false, :is_copyright_holder => false})

  ##################
  # Access Control #
  ##################

  def can_be_updated_by?(user)
    publishable.can_be_updated_by?(user)
  end

  def can_be_accepted_by?(user)
    user == self.user
  end
  
  def can_be_destroyed_by?(user)
    user == self.user || \
      (publishable.can_be_updated_by?(user) && !is_author && !is_copyright_holder)
  end
end
