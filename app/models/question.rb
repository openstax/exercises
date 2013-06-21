class Question < ActiveRecord::Base
  attr_accessible :content, :content_html, :credit, :exercise_id, :order
end
