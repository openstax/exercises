class Exercise < ActiveRecord::Base

  acts_as_votable
  parsable :stimulus
  publishable
  has_attachments
  has_logic :javascript, :latex

  has_many :questions, dependent: :destroy, autosave: true
  has_many :stems, through: :questions
  has_many :answers, through: :questions

  has_many :stylings, through: :stems

  has_many :list_exercises, :dependent => :destroy
  has_many :lists, :through => :list_exercises

  protected

  def has_questions
    return unless questions.first.nil?
    errors.add(:questions, "can't be blank")
    false
  end

end
