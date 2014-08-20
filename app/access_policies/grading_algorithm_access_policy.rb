class GradingAlgorithmAccessPolicy
  # Contains all the rules for which requestors can do what with which GradingAlgorithm objects.

  def self.action_allowed?(action, requestor, grading_algorithm)
    false
  end

end
