# Load the rails application
require File.expand_path('../application', __FILE__)

require 'user_mapper'

require 'style'
require 'solution_type'
require 'language'

require 'has_attachments'
require 'has_logic'
require 'has_tags'

require 'parsable'
require 'publishable'
require 'stylable'

#require 'importers/quadbase'

SITE_NAME = "OpenStax Exercises"
COPYRIGHT_HOLDER = "Rice University"

# Initialize the rails application
Exercises::Application.initialize!
