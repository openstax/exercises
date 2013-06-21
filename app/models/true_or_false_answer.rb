class TrueOrFalseAnswer < ActiveRecord::Base
  attr_accessible :content, :content_html, :credit, :is_true, :order, :question_id
end
