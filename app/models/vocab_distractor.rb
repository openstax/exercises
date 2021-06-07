class VocabDistractor < ApplicationRecord
  belongs_to :vocab_term, inverse_of: :vocab_distractors
  belongs_to :distractor_publication_group, class_name: 'PublicationGroup',
                                            inverse_of: :vocab_distractors

  validates :distractor_publication_group, uniqueness: { scope: :vocab_term_id }
  validates :distractor_term, presence: true

  validate :vocab_term_publication_group, :different_terms

  before_save :save_distractor_term

  delegate :group_uuid, :number, to: :distractor_publication_group, allow_nil: true
  delegate :tags, :uuid, :version, :uid, :published_at, :license, :authors, :copyright_holders,
           :delegations, :derivations, :nickname, :name, :definition, :solutions_are_public,
           to: :distractor_term

  def reload
    @distractor_term = nil

    super
  end

  def distractor_publication_group_id=(new_id)
    @distractor_term = nil if new_id != distractor_publication_group_id

    super
  end

  def distractor_publication_group=(new_publication_group)
    @distractor_term = nil if new_publication_group != distractor_publication_group

    super
  end

  def group_uuid=(new_group_uuid)
    @distractor_term = nil if new_group_uuid != group_uuid

    self.distractor_publication_group = PublicationGroup.find_by(
      uuid: new_group_uuid, publishable_type: 'VocabTerm'
    )
  end

  def number=(new_number)
    @distractor_term = nil if new_number != number

    self.distractor_publication_group = PublicationGroup.find_by(
      number: new_number, publishable_type: 'VocabTerm'
    )
  end

  def distractor_term
    return @distractor_term unless @distractor_term.nil?
    return if distractor_publication_group.nil?

    distractor_publications ||= distractor_publication_group.publications
    published_publications = distractor_publications.select(&:is_published?)
    publication_pool = published_publications.any? ? published_publications :
                                                     distractor_publications
    @distractor_term = publication_pool.max_by(&:version).try!(:publishable)
  end

  def distractor_term=(other_term)
    self.distractor_publication_group = other_term.try!(:publication).try!(:publication_group)
    @distractor_term = other_term
  end

  protected

  def vocab_term_publication_group
    return if distractor_publication_group.nil? ||
              distractor_publication_group.publishable_type == 'VocabTerm'
    errors.add(:distractor_publication_group, 'must be a VocabTerm PublicationGroup')
    false
  end

  def different_terms
    return if vocab_term != distractor_term
    errors.add(:distractor_term, 'cannot be the same as the vocab_term')
    false
  end

  def save_distractor_term
    @distractor_term.save unless @distractor_term.nil? || @distractor_term.persisted?
    self.distractor_publication_group_id ||= @distractor_term.publication.publication_group_id
  end
end
