# Copyright 2011-2014 Rice University. Licensed under the Affero General Public
# License version 3 or later.  See the COPYRIGHT file for details.

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '< 7'

# Psych 4 (included in Ruby 3.1) breaks Rails < 7
# Remove this entry completely when updating to Rails 7
gem 'psych', '< 4'

# Sprockets 4 requires a manifest file which we don't really need and it's maybe gone in Rails 7
gem 'sprockets', '< 4'

# Bootstrap
gem 'bootstrap-sass'

# Use SCSS for stylesheets
gem 'sass-rails'

# Use Uglifier as compressor for JS assets
gem 'uglifier'

# V8 bindings to precompile JS assets
gem 'mini_racer'

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

# Sanitizes user content
gem 'sanitize'

# ActiveStorage variants
gem 'image_processing'

# ActiveStorage S3 support
gem 'aws-sdk-s3'

# Cache values for the duration of a request
gem 'request_store'

# Fetch and parse OpenStax book content
gem 'openstax_content'

# Utilities for OpenStax websites
gem 'openstax_utilities'

# Talks to Accounts (latest version is broken)
gem 'omniauth-oauth2'

# OpenStax Accounts integration
gem 'openstax_accounts'

# Access control for API's
gem 'doorkeeper'

# API versioning and documentation
gem 'representable'
gem 'openstax_api'
gem 'apipie-rails'
gem 'maruku'

# Retry failed database transactions
gem 'openstax_transaction_retry'
gem 'openstax_transaction_isolation'

# Lev framework
gem 'lev'

# Contract management
gem 'fine_print'

# Keyword search
gem 'keyword_search'

# Read Excel xlsx spreadsheet files
gem 'roo'

# Embedded JavaScript templates
gem 'ejs'

# Object cloning
gem 'deep_cloneable'

# Sortable objects
gem 'sortability'

# Comment voting
gem 'acts_as_votable'

# Real time application monitoring
gem 'scout_apm'

# PostgreSQL database
gem 'pg'

# Support systemd Type=notify services for puma
gem 'sd_notify', require: false

# Use the puma webserver
gem 'puma'

# Prevent server memory from growing until OOM
gem 'puma_worker_killer'

# HTTP requests
gem 'httparty'

# Notify developers of Exceptions in production
gem 'openstax_rescue_from'

# Sentry integration (the require disables automatic Rails integration since we use rescue_from)
gem 'sentry-ruby'

# Fast JSON parsing
gem 'oj'

# Replace JSON with Oj
gem 'oj_mimic_json'

# Key-value store for caching
gem 'redis'

# Respond to ELB healthchecks in /ping and /ping/
gem 'openstax_healthcheck'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Bulk inserts and upserts
gem 'activerecord-import'

# Get env variables from .env file
gem 'dotenv-rails'

# Cron job scheduling
gem 'whenever'

# Markdown parsing
gem 'kramdown'

group :development, :test do
  # Run specs in parallel
  gem 'parallel_tests'

  # Show failing specs instantly
  gem 'rspec-instafail'

  # Thin webserver
  gem 'thin'

  # Call 'debugger' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Use RSpec for tests
  gem 'rspec-rails'

  # Mute asset pipeline log messages

  # Fixture replacement
  gem 'factory_bot_rails'

  # Lorem Ipsum
  gem 'faker'

  # Database cleaning functionality for tests
  gem 'database_cleaner'
end

group :development do
  # Listen for file changes in development
  gem 'listen'

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

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
end

group :test do
  # Spec helpers
  gem 'shoulda-matchers', require: false

  # Stubs HTTP requests
  gem 'webmock'

  # Records HTTP requests
  gem 'vcr'

  # Codecov integration
  gem 'codecov', require: false

  # Rubocop
  gem 'rubocop-rails'
end

group :production do
  # Used to backup the database before migrations
  gem 'aws-sdk-rds', require: false

  # Used to record a lifecycle action heartbeat after creating the RDS snapshot before migrating
  gem 'aws-sdk-autoscaling', require: false

  # Fog AWS
  gem 'fog-aws'

  # Lograge for consistent logging
  gem 'lograge'
end
