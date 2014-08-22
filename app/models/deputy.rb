class Deputy < ActiveRecord::Base

  belongs_to :deputizer, class_name: 'User', inverse_of: :deputies
  belongs_to :deputy, class_name: 'User', inverse_of: :deputizers

  validates :deputizer, presence: true
  validates :deputy, presence: true, uniqueness: { scope: :deputizer_id }
  validate :different_ids

  protected

  def different_ids
    return if deputizer_id != deputy_id
    errors.add(:base, 'You cannot be your own deputy.')
    false
  end

end
