class Tag < ActiveRecord::Base
  has_many :exercise_tags, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
