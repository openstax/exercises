class List < ActiveRecord::Base
  attr_accessible :editor_user_group_id, :manager_user_group_id, :name, :publisher_user_group_id, :reader_user_group_id
end
