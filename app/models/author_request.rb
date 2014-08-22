class AuthorRequest < ActiveRecord::Base

  belongs_to :requestor, class_name: 'User', inverse_of: :sent_author_requests
  belongs_to :collaborator, inverse_of: :author_request

  validates :requestor, presence: true
  validates :collaborator, presence: true, uniqueness: true

end
