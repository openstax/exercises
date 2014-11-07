class Exercise < ActiveRecord::Base

  acts_as_votable
  parsable :background
  publishable
  has_attachments
  has_logic :javascript, :latex

  has_many :questions, dependent: :destroy, autosave: true
  has_many :stems, through: :questions
  has_many :answers, through: :questions

  has_many :list_exercises, :dependent => :destroy
  has_many :lists, :through => :list_exercises

  protected

  def has_parts
    return unless parts.first.nil?
    errors.add(:parts, "can't be blank")
    false
  end

  def has_content
    return unless background.blank?
    errors.add(:content, "can't be blank")
    false
  end

end
