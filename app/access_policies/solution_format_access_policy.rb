class SolutionFormatAccessPolicy
  # Contains all the rules for which requestors can do what with which SolutionFormat objects.

  def self.action_allowed?(action, requestor, solution_format)
    false
  end

end
