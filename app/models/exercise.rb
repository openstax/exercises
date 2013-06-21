class Exercise < ActiveRecord::Base
  attr_accessible :changes_solution, :content, :content_html, :embargoed_until, :license_id, :locked_at, :locked_by, :number, :only_embargo_solutions, :suggested_credit, :version
end
