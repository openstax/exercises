class Exercise < ActiveRecord::Base

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
              answers: :stem_answers,
              stems: [:stylings, :combo_choices]
            ])
  }

  protected

  def has_questions
    return unless questions.first.nil?
    errors.add(:questions, "can't be blank")
    false
  end

end
