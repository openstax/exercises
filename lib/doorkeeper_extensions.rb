require 'doorkeeper/models/application'

Doorkeeper::Application.class_eval do
  attr_accessible :trusted
end

OSU::AccessPolicy.register(Doorkeeper::Application, Doorkeeper::ApplicationAccessPolicy)
