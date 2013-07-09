class Collaborator < ActiveRecord::Base
  sortable [:collaborable_type, :collaborable_id]

  attr_accessible :toggle_author_request, :toggle_copyright_holder_request

  belongs_to :collaborable, :polymorphic => true

  belongs_to :user
  belongs_to :requester, :class_name => 'User'

  validates_presence_of :user, :collaborable
  validates_uniqueness_of :user_id, :scope => [:collaborable_type, :collaborable_id]

  ##################
  # Access Control #
  ##################
end
