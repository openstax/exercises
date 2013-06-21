class MatchingAnswer < ActiveRecord::Base
  attr_accessible :content, :content_html, :credit, :match_number, :order, :question_id, :right_column
end
