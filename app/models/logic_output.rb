class LogicOutput < ActiveRecord::Base
  belongs_to :logic

  attr_accessible #:logic_id, :seed, :values

  delegate_access_control to: :logic
end
