class FreeResponse < ActiveRecord::Base
  attr_accessible :content, :content_html, :credit, :free_response, :order, :question_id
end
