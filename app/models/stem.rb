class Stem < ApplicationRecord
  user_html :content
  stylable

  attr_accessor :temp_id

  belongs_to :question

  has_many :stem_answers, dependent: :destroy

  has_many :combo_choices, dependent: :destroy

  validates :stylings, presence: true
  validates :content, presence: true

  def flattened_content
    ([ content ] + stem_answers.map { |sa| sa.answer.content } ).join("\n")
  end
end
