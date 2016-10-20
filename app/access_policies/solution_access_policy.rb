class SolutionAccessPolicy
  # Contains all the rules for which requestors can do what with which Solution objects.

  def self.action_allowed?(action, requestor, solution)
    case action
    when :index
      true
    when :read
      solution.is_published? ||
      solution.has_read_permission?(requestor)
    when :create
      !solution.is_persisted? &&
      solution.has_write_permission?(requestor)
    when :update, :destroy
      solution.has_write_permission?(requestor)
    else
      false
    end
  end

end
