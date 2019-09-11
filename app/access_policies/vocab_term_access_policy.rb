class VocabTermAccessPolicy
  # Contains all the rules for which requestors can do what with which VocabTerms

  def self.action_allowed?(action, requestor, vocab_term)
    case action
    when :search
      true
    when :create
      !requestor.is_anonymous? && requestor.is_human?
    when :read
      vocab_term.has_read_permission?(requestor) || requestor.is_administrator?
    when :update, :destroy
      !vocab_term.is_published? && vocab_term.has_write_permission?(requestor)
    when :new_version
      vocab_term.is_published? && vocab_term.has_write_permission?(requestor)
    else
      false
    end
  end

end
