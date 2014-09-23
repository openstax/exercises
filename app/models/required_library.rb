class RequiredLibrary < ActiveRecord::Base

  belongs_to :library, inverse_of: :required_library

  validates :library, presence: true, uniqueness: true

end
