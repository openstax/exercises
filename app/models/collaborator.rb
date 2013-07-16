class Collaborator < ActiveRecord::Base
  sortable [:publishable_type, :publishable_id]

  belongs_to :publishable, :polymorphic => true

  belongs_to :user, :inverse_of => :collaborators

  attr_accessible :toggle_author_request, :toggle_copyright_holder_request

  validates_presence_of :user, :publishable
  validates_uniqueness_of :user_id, :scope => [:publishable_type, :publishable_id]

  scope :roleless, where({:is_author => false, :is_copyright_holder => false})

  ##################
  # Access Control #
  ##################
end