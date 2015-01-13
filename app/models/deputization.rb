class Deputization < ActiveRecord::Base

  belongs_to :deputizer, class_name: 'User', inverse_of: :child_deputizations
  belongs_to :deputy, polymorphic: true

  validates :deputy, presence: true
  validates :deputizer, presence: true,
                        uniqueness: { scope: [:deputy_type, :deputy_id] }

end
