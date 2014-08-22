class CopyrightHolderRequest < ActiveRecord::Base

  belongs_to :requestor, class_name: 'User', inverse_of: :sent_copyright_holder_requests
  belongs_to :collaborator, inverse_of: :copyright_holder_request

  validates :requestor, presence: true
  validates :collaborator, presence: true, uniqueness: true

end
