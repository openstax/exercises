class Derivation < ApplicationRecord

  sortable_belongs_to :derived_publication, class_name: 'Publication', inverse_of: :sources
  belongs_to :source_publication, class_name: 'Publication', inverse_of: :derivations, optional: true

  validates :source_publication, uniqueness: { scope: :derived_publication_id, allow_nil: true }
  validate :different_publications, :source_or_custom

  protected

  def different_publications
    return if source_publication != derived_publication
    errors.add(:base, 'must have different publications')
    false
  end

  def source_or_custom
    return unless source_publication.nil? && custom_attribution.blank?
    errors.add(:base, 'must have either a source publication or custom attribution')
    false
  end

end
