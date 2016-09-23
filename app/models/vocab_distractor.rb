class VocabDistractor < ActiveRecord::Base
  belongs_to :vocab_term, inverse_of: :vocab_distractors

  validates :vocab_term, presence: true
  validates :distractor_term, presence: true
  validates :distractor_term_number, uniqueness: { scope: :vocab_term_id }

  before_save :save_distractor_term

  delegate :tags, :uid, :version, :published_at, :license, :editors, :authors,
           :copyright_holders, :derivations, :name, :definition, to: :distractor_term

  def reload
    @distractor_term = nil
    super
  end

  def number
    distractor_term_number
  end

  def distractor_term_number=(number)
    @distractor_term = nil if number != distractor_term_number
    super
  end

  def distractor_term
    return @distractor_term unless @distractor_term.nil?

    distractor_publications ||= Publication
      .joins(:publication_group)
      .where(publishable_type: 'VocabTerm', publication_group: {number: distractor_term_number})
    published_publications = distractor_publications.select(&:is_published?)
    publication_pool = published_publications.any? ? published_publications :
                                                     distractor_publications
    @distractor_term = publication_pool.max_by(&:version).try(:publishable)
  end

  def distractor_term=(other_term)
    self.distractor_term_number = other_term.try(:publication).try(:number)
    @distractor_term = other_term
  end

  protected

  def save_distractor_term
    @distractor_term.save unless @distractor_term.nil? || @distractor_term.persisted?
    self.distractor_term_number ||= @distractor_term.number
  end
end
