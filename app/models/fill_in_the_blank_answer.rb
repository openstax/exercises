class FillInTheBlankAnswer < ActiveRecord::Base
  attr_accessible :blank_answer, :credit, :order, :post_content, :post_content_html, :pre_content, :pre_content_html, :question_id
end
