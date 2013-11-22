class Part < ActiveRecord::Base
  sortable 

  belongs_to :exercise, inverse_of: :parts
  belongs_to :background, class_name: 'Content'
  has_many :solutions, :dependent => :destroy, :inverse_of => :part
  has_many :questions

  attr_accessible :background_id, :credit, :exercise_id, :position

  validate :exercise_id, presence: true
end
