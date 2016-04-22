class VocabTermAccessPolicy
  # Contains all the rules for which requestors can do what with which VocabTerm objects.

  def self.action_allowed?(action, requestor, vocab_term)
    case action
    when :search
      true
    when :create
      !requestor.is_anonymous? && requestor.is_human? && !vocab_term.persisted?
    when :read
      vocab_term.has_collaborator?(requestor) || requestor.is_administrator?
    when :update, :destroy
      !vocab_term.is_published? && vocab_term.has_collaborator?(requestor) || \
      requestor.is_administrator?
    when :new_version
      vocab_term.is_published? && \
      (vocab_term.has_collaborator?(requestor) || requestor.is_administrator?)
    else
      false
    end
  end

end
