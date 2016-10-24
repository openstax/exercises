class CommunitySolutionAccessPolicy
  # Contains all the rules for which requestors can do what with which CommunitySolutions

  def self.action_allowed?(action, requestor, community_solution)
    case action
    when :search
      true
    when :create
      !requestor.is_anonymous? &&
      requestor.is_human? &&
      ( community_solution.question.exercise.is_public? ||
        community_solution.question.exercise.has_read_permission?(requestor) )
    when :read
      community_solution.has_read_permission?(requestor) ||
      ( community_solution.is_public? &&
        ( community_solution.question.exercise.is_public? ||
          community_solution.question.exercise.has_read_permission?(requestor) ) )
    when :update, :destroy
      !community_solution.is_published? && community_solution.has_write_permission?(requestor)
    when :new_version
      community_solution.is_published? && community_solution.has_write_permission?(requestor)
    else
      false
    end
  end

end
