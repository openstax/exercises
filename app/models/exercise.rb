class Exercise < ActiveRecord::Base

  acts_as_votable
  parsable :stimulus
  publishable
  has_attachments
  has_logic :javascript, :latex

  has_many :questions, dependent: :destroy, autosave: true

  has_many :list_exercises, dependent: :destroy

  has_many :exercise_tags, dependent: :destroy

  protected

  def has_questions
    return unless questions.first.nil?
    errors.add(:questions, "can't be blank")
    false
  end

end
