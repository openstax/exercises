class UserProfile < ActiveRecord::Base
  attr_accessible :announcement_email, :auto_author_subscribe, :collaborator_request_email, :group_member_email, :user_id
end
