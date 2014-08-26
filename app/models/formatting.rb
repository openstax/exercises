class Formatting < ActiveRecord::Base

  belongs_to :formattable, polymorphic: true
  belongs_to :format, inverse_of: :question_formats

  validates :formattable, presence: true
  validates :format, presence: true, uniqueness: {
    scope: [:formattable_id, :formattable_type] }

end