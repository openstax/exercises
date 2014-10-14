# Load the rails application
require File.expand_path('../application', __FILE__)

require 'format'
require 'language'

require 'publishable'
require 'sortable'
require 'has_attachments'
require 'has_logic'

SITE_NAME = "OpenStax Exercises"
COPYRIGHT_HOLDER = "Rice University"

# Initialize the rails application
Exercises::Application.initialize!
