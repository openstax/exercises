class Derivation < ActiveRecord::Base
  sortable [:publishable_type, :derived_publishable_id]

  belongs_to :source_publishable, :polymorphic => true, :foreign_type => 'publishable_type'
  belongs_to :derived_publishable, :polymorphic => true, :foreign_type => 'publishable_type'

  attr_accessible :source_publishable, :derived_publishable

  validates_presence_of :source_publishable, :derived_publishable
  validates_uniqueness_of :derived_publishable_id, :scope => [:publishable_type, :source_publishable_id]

  ##################
  # Access Control #
  ##################

  def can_be_destroyed_by?(user)
    derived_publishable.can_be_updated_by?(user)
  end
end
