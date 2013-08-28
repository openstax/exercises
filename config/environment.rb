# Load the rails application
require File.expand_path('../application', __FILE__)

require 'utilities'
require 'shared_application_methods'
require 'api_constraints'

require 'attachable'
require 'content'
require 'exercise_search'
require 'publishable'
require 'solution_search'
require 'sortable'
require 'user_search'

SITE_NAME = "OpenStax Exercises"
COPYRIGHT_HOLDER = "Rice University"

# Initialize the rails application
Exercises::Application.initialize!
