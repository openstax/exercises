class SolutionAccessPolicy
  # Contains all the rules for which requestors can do what with which Solution objects.

  def self.action_allowed?(action, requestor, solution)
    false
  end

end
