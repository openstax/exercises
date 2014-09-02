require 'doorkeeper/models/application'

Doorkeeper::Application.class_eval do
  attr_accessible :trusted
end

Doorkeeper::ApplicationController.layout :application_body_only

OSU::AccessPolicy.register(Doorkeeper::Application, Doorkeeper::ApplicationAccessPolicy)
