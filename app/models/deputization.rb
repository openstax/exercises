class Deputization < ApplicationRecord

  belongs_to :deputizer, class_name: 'User', inverse_of: :child_deputizations
  belongs_to :deputy, polymorphic: true

  validates :deputizer, uniqueness: { scope: [:deputy_type, :deputy_id] }

end
