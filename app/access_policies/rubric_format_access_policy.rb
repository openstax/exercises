class RubricFormatAccessPolicy
  # Contains all the rules for which requestors can do what with which RubricFormat objects.

  def self.action_allowed?(action, requestor, rubric_format)
    false
  end

end
