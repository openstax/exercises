class RubricAccessPolicy
  # Contains all the rules for which requestors can do what with which Rubric objects.

  def self.action_allowed?(action, requestor, rubric)
    false
  end

end
