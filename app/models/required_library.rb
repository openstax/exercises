class RequiredLibrary < ActiveRecord::Base

  belongs_to :library

  validates :library, presence: true, uniqueness: true

end
