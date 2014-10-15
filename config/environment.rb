# Load the rails application
require File.expand_path('../application', __FILE__)

require 'style'
require 'language'

require 'publishable'
require 'sortable'
require 'has_attachments'
require 'has_logic'

require 'importers/quadbase_question'

SITE_NAME = "OpenStax Exercises"
COPYRIGHT_HOLDER = "Rice University"

# Initialize the rails application
Exercises::Application.initialize!
