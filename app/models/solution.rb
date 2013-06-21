class Solution < ActiveRecord::Base
  attr_accessible :content, :content_html, :question_id, :summary
end
