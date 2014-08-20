class PartDependencyAccessPolicy
  # Contains all the rules for which requestors can do what with which PartDependency objects.

  def self.action_allowed?(action, requestor, part_dependency)
    false
  end

end
