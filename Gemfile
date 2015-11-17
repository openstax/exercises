# Copyright 2011-2014 Rice University. Licensed under the Affero General Public
# License version 3 or later.  See the COPYRIGHT file for details.

source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'

# Bootstrap
gem 'bootstrap-sass', '~> 3.2.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Compass stylesheets
gem 'compass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# jquery UI library
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Automatically add browser-specific CSS prefixes
gem 'autoprefixer-rails'

# Rails 5 HTML sanitizer
gem 'rails-html-sanitizer'

# URI replacement
gem 'addressable'

# Converts links in Strings to HTML anchors
gem 'rails_autolink'

# Utilities for OpenStax websites
gem 'openstax_utilities'

# Cron job scheduling
gem 'whenever'

# OpenStax Accounts integration
gem 'openstax_accounts', '~> 6.1.6'

# Access control for API's
gem 'doorkeeper'

# API versioning and documentation
gem 'representable', '~> 2.2.3'
gem 'openstax_api', '~> 6.1.0'
gem 'apipie-rails'
gem 'maruku'

# Lev framework
gem 'lev'

# Ruby dsl for SQL queries
gem 'squeel'

# Contract management
gem 'fine_print'

# Keyword search
gem 'keyword_search'

# File uploads
gem 'remotipart'
gem 'carrierwave'

# Image editing
gem 'mini_magick'

# Markdown parsing
gem 'kramdown'

# Detect import encoding
gem 'charlock_holmes'

# Read Excel xlsx spreadsheet files
gem 'roo'

# Embedded JavaScript templates
gem 'ejs'

# Embedded CoffeeScript templates
gem 'eco'

# Object cloning
gem 'deep_cloneable'

# Sortable objects
gem 'sortability'

# Comments on objects
gem 'commontator'

# Comment voting
gem 'acts_as_votable'

# Real time application monitoring
gem 'newrelic_rpm'

# YAML database backups
gem 'yaml_db'

# Admin console
gem 'rails_admin'

# PostgreSQL database
gem 'pg'

gem 'openstax_rescue_from', '~> 1.5.0'

group :development, :test do
  # Run specs in parallel
  gem "parallel_tests"

  # Show failing specs instantly
  gem "rspec-instafail"

  # Thin webserver
  gem 'thin'

  # Call 'debugger' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Use RSpec for tests
  gem 'rspec-rails'

  # Mute asset pipeline log messages
  gem 'quiet_assets'

  # Fixture replacement
  gem 'factory_girl_rails'

  # Lorem Ipsum
  gem 'faker'
end

group :development do
  # Automated security checks
  gem 'brakeman'

  # Time travel gem
  gem 'timecop'

  # Command line reference
  gem 'cheat'

  # Assorted generators
  gem 'nifty-generators'

  # Class diagrams
  gem 'rails-erd'
  gem 'railroady'

  # CoffeeScript source maps
  gem 'coffee-rails-source-maps'
end

group :test do
  # Spec helpers
  gem 'shoulda-matchers', require: false

  # Code Climate integration
  gem "codeclimate-test-reporter", require: false

  # Coveralls integration
  gem 'coveralls', require: false

  # Test after-commit hooks
  gem 'test_after_commit'
end

group :production do
  # Unicorn production server
  gem 'unicorn'

  # Unicorn worker killer
  gem 'unicorn-worker-killer'

  # AWS SES
  gem 'aws-ses', '~> 0.6.0', require: 'aws/ses'

  # Fog
  gem 'fog', require: 'fog/aws'

  # Lograge for consistent logging
  gem 'lograge'
end
