class SolutionAccessPolicy
  # Contains all the rules for which requestors can do what with which Solution objects.

  def self.action_allowed?(action, requestor, solution)
    case action
    when :index
      true
    when :show
      solution.has_collaborator?(requestor) ||\
        solution.is_published?
    when :create
      solution.has_collaborator?(requestor) && \
        !solution.is_persisted?
    when :update, :destroy
      solution.has_collaborator?(requestor)
    else
      false
    end
  end

end
