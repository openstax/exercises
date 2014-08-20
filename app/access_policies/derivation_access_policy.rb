class DerivationAccessPolicy
  # Contains all the rules for which requestors can do what with which Derivation objects.

  def self.action_allowed?(action, requestor, derivation)
    false
  end

end
