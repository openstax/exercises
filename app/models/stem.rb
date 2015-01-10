class Stem < ActiveRecord::Base

  parsable :content
  stylable

  attr_accessor :temp_id

  belongs_to :question

  has_many :stem_answers, dependent: :destroy

  has_many :combo_choices, dependent: :destroy

  validates :question, presence: true

end
