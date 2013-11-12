class Part < ActiveRecord::Base
  belongs_to :exercise, inverse_of: :parts
  has_many :solutions, :dependent => :destroy, :inverse_of => :part

  attr_accessible :background_id, :credit, :exercise_id, :position
end
