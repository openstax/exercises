class ExerciseLicenses < ActiveRecord::Base
  belongs_to :exercise
  belongs_to :license
  attr_accessible :request_attribution, :start_at
end
