class Collaborator < ActiveRecord::Base
  sortable [:collaborable_type, :collaborable_id]

  belongs_to :collaborable, :polymorphic => true

  belongs_to :user

  attr_accessible :toggle_author_request, :toggle_copyright_holder_request

  validates_presence_of :user, :collaborable
  validates_uniqueness_of :user_id, :scope => [:collaborable_type, :collaborable_id]

  ##################
  # Access Control #
  ##################
end
