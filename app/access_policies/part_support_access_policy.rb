class PartSupportAccessPolicy
  # Contains all the rules for which requestors can do what with which PartSupport objects.

  def self.action_allowed?(action, requestor, part_support)
    false
  end

end
