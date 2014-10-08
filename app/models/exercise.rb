class Exercise < ActiveRecord::Base

  acts_as_votable
  publishable
  has_attachments
  has_logic :javascript, :latex

  has_many :parts, dependent: :destroy, inverse_of: :exercise, autosave: true
  has_many :questions, through: :parts
  has_many :items, through: :questions
  has_many :answers, through: :questions
  has_many :combo_choices, through: :questions

  has_many :list_exercises, :dependent => :destroy, :inverse_of => :exercise
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
