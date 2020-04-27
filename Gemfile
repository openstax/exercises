# Copyright 2011-2014 Rice University. Licensed under the Affero General Public
# License version 3 or later.  See the COPYRIGHT file for details.

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'

# Bootstrap
gem 'bootstrap-sass'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Compass stylesheets
gem 'compass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2.2'

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

# Converts links in Strings to HTML anchors
gem 'rinku'

# Sanitizes user content
gem 'sanitize'

# Utilities for OpenStax websites
gem 'openstax_utilities'

# Cron job scheduling
gem 'whenever'

# Talks to Accounts (latest version is broken)
gem 'omniauth-oauth2'

# OpenStax Accounts integration
gem 'openstax_accounts', '~> 9.0.3'

# Access control for API's
gem 'doorkeeper'

# API versioning and documentation
gem 'representable', '~> 3.0.0'
gem 'openstax_api'
gem 'apipie-rails'
gem 'maruku'

# Lev framework
gem 'lev'

# Contract management
gem 'fine_print'

# Keyword search
gem 'keyword_search'

# File uploads
gem 'remotipart'
gem 'carrierwave'
gem 'mimemagic'

# Image editing
gem 'mini_magick'

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

# Comment voting
gem 'acts_as_votable'

# Real time application monitoring
gem 'scout_apm', '~> 3.0.pre28'

# PostgreSQL database
gem 'pg'

# HTTP requests
gem 'httparty'

gem 'a15k_client',
    git: 'https://github.com/a15k/mothership.git',
    glob: 'clients/1.0.0/ruby/*gemspec',
    branch: 'master'

# Notify developers of Exceptions in production
gem 'openstax_rescue_from'

# Sentry integration (the require disables automatic Rails integration since we use rescue_from)
gem 'sentry-raven', require: 'raven/base'

# API JSON rendering/parsing
# Do not use Roar 1.0.4
# Also, do not use Roar::Hypermedia links
gem 'roar', '1.0.3'

# Fast JSON parsing
gem 'oj'

# Replace JSON with Oj
gem 'oj_mimic_json'

# Key-value store for caching
gem 'redis-rails'

# Respond to ELB healthchecks in /ping and /ping/
gem 'openstax_healthcheck'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.4.0', require: false

# Bulk inserts and upserts
gem 'activerecord-import'

group :development, :test do
  # Get env variables from .env file
  gem 'dotenv-rails'

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

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
end

group :test do
  # Spec helpers
  gem 'shoulda-matchers', require: false

  # Code Climate integration
  gem "codeclimate-test-reporter", require: false

  # Codecov integration
  gem 'codecov', require: false

  # Rubocop
  gem 'rubocop-rails'
end

group :production do
  # Unicorn production server
  gem 'unicorn'

  # Unicorn worker killer
  gem 'unicorn-worker-killer'

  # AWS SES
  gem 'aws-ses', '~> 0.6.0', require: 'aws/ses'

  # Fog AWS
  gem 'fog-aws'

  # Lograge for consistent logging
  gem 'lograge'
end
