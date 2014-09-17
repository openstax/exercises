class Deputization < ActiveRecord::Base

  sortable

  belongs_to :deputizer, class_name: 'User', inverse_of: :child_deputizations
  belongs_to :deputy, polymorphic: true

  validates :deputy, presence: true
  validates :deputizer, presence: true, uniqueness: { scope: [:deputy_id, :deputy_type] }

  delegate_access_control_to :deputizer

end
