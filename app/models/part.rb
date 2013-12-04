class Part < ActiveRecord::Base
  sortable 

  belongs_to :exercise, inverse_of: :parts
  belongs_to :background, class_name: 'Content'
  has_many :solutions, :dependent => :destroy, :inverse_of => :part
  has_many :questions

  attr_accessible :credit, :background_attributes

  accepts_nested_attributes_for :background

  validate :exercise_id, presence: true

  delegate :can_be_read_by?, 
           :can_be_created_by?, 
           :can_be_updated_by?, 
           :can_be_destroyed_by?, 
           to: :exercise

end
