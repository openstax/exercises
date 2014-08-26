class Derivation < ActiveRecord::Base

  sortable :derived_publication_id

  belongs_to :source_publication, class_name: 'Publication', inverse_of: :derivations
  belongs_to :derived_publication, class_name: 'Publication', inverse_of: :sources

  validates :derived_publication, presence: true,
            uniqueness: { scope: :source_publication_id }
  validate :different_ids, :source_or_custom

  protected

  def different_ids
    return if source_publication_id != derived_publication_id
    errors.add(:base, 'An object cannot be derived from itself.')
    false
  end

  def source_or_custom
    return if source_publication_id || custom_attribution
    errors.add(:base, 'must have either a source publication or a custom attribution')
    false
  end

end
