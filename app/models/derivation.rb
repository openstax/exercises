class Derivation < ActiveRecord::Base

  sortable

  belongs_to :derived_publication, class_name: 'Publication'
  belongs_to :source_publication, class_name: 'Publication'

  validates :derived_publication, presence: true
  validates :source_publication,
            uniqueness: { scope: :derived_publication_id }, allow_nil: true
  validate :different_ids, :source_or_custom

  protected

  def different_ids
    return if source_publication_id != derived_publication_id
    errors.add(:derived_publication, 'cannot be derived from itself.')
    false
  end

  def source_or_custom
    return unless source_publication_id.nil? && custom_attribution.blank?
    errors.add(:base,
               'must have either a source publication or a custom attribution')
    false
  end

end
