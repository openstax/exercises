class UserGroupMember < ActiveRecord::Base
  attr_accessible :is_group_manager, :user_group_id, :user_id
end
