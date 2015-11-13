class Exercise < ActiveRecord::Base

  # deep_clone does not iterate through hashes, so each hash must have only 1 key
  NEW_VERSION_DUPED_ASSOCIATIONS = [
    :attachments,
    :logic,
    :tags,
    {
      publication: [
        :derivations,
        :authors,
        :copyright_holders,
        :editors
      ]
    },
    {
      questions: [
        :hints,
        :answers,
        {
          stems: [
            :stylings,
            :combo_choices,
            {
              stem_answers: :answer
            }
          ]
        }
      ]
    }
  ]

  acts_as_votable
  parsable :stimulus
  publishable
  has_attachments
  has_logic :javascript, :latex
  has_tags

  has_many :questions, dependent: :destroy, autosave: true

  has_many :list_exercises, dependent: :destroy

  scope :preloaded, -> {
    preload(:attachments,
            :logic,
            :tags,
            publication: [:derivations,
                          authors: :user,
                          copyright_holders: :user,
                          editors: :user],
            questions: [
              :hints,
              :solutions,
              answers: :stem_answers,
              stems: [:stylings, :combo_choices]
            ])
  }

  def new_version
    nv = deep_clone include: NEW_VERSION_DUPED_ASSOCIATIONS, use_dictionary: true
    nv.publication.version = version + 1
    nv.publication.published_at = nil
    nv.publication.yanked_at = nil
    nv.publication.embargoed_until = nil
    nv.publication.major_change = false
    nv
  end

  protected

  def has_questions
    return unless questions.first.nil?
    errors.add(:questions, "can't be blank")
    false
  end

end
