class Favorite < ActiveRecord::Base
  belongs_to :publication, inverse_of: :favorites
  belongs_to :user

  validates :publication, presence: true
  validates :user, presence: true, uniqueness: { scope: :publication_id }

  delegate :name, to: :user
end
