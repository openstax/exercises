# Load the rails application
require File.expand_path('../application', __FILE__)

require 'utilities'
require 'shared_application_methods'
require 'api_constraints'
require 'sortable'
require 'content'

SITE_NAME = "OpenStax Exercises"
COPYRIGHT_HOLDER = "Rice University"

# Initialize the rails application
Exercises::Application.initialize!
