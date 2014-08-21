class LogicOutput < ActiveRecord::Base
  belongs_to :logic

  delegate_access_control to: :logic

  # TODO in values, only allow strings and numbers.
end
