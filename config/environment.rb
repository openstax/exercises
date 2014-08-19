# Load the rails application
require File.expand_path('../application', __FILE__)

require 'publishable'
require 'sortable'
require 'logic'
require 'user_search'
require 'exercise_search'
require 'solution_search'

SITE_NAME = "OpenStax Exercises"
COPYRIGHT_HOLDER = "Rice University"

# Initialize the rails application
Exercises::Application.initialize!
