class Solution < ActiveRecord::Base
  attr_accessible :content, :content_html, :creator_id, :number, :question_id, :summary, :version
end
