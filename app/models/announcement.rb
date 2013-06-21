class Announcement < ActiveRecord::Base
  attr_accessible :body, :creator_id, :force, :subject
end
