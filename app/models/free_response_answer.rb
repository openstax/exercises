class FreeResponseAnswer < ActiveRecord::Base
  attr_accessible :can_be_sketched, :content, :content_html, :credit, :free_response, :order, :question_id
end
