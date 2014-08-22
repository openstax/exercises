class Derivation < ActiveRecord::Base

  sortable [:publishable_type, :derived_publishable_id]

  belongs_to :source_publishable, :polymorphic => true, :foreign_type => :publishable_type
  belongs_to :derived_publishable, :polymorphic => true, :foreign_type => :publishable_type

  validates :source_publishable, presence: true
  validates :derived_publishable, presence: true,
            uniqueness: { scope: [:publishable_type, :source_publishable_id] }
  validate :different_ids

  protected

  def different_ids
    return if source_publishable_id != derived_publishable_id
    errors.add(:base, 'An object cannot be derived from itself.')
    false
  end

end
