class MultipleChoiceAnswer < ActiveRecord::Base
  attr_accessible :content, :content_html, :credit, :order, :question_id
end
