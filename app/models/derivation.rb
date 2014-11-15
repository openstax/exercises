class Derivation < ActiveRecord::Base

  sortable container: :derived_publication, records: :sources,
           scope: :derived_publication_id

  belongs_to :derived_publication, class_name: 'Publication'
  belongs_to :source_publication, class_name: 'Publication'

  validates :derived_publication, presence: true
  validates :source_publication, uniqueness: { scope: :derived_publication_id }
  validate :different_ids, :source_or_custom

  protected

  def different_publications
    return if source_publication != derived_publication
    errors.add(:base, 'must have different publications')
    false
  end

  def source_or_custom
    return unless source_publication.nil? && custom_attribution.blank?
    errors.add(:base,
               'must have either a source publication or custom attribution')
    false
  end

end
