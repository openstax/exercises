# Copyright 2011-2013 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

source 'https://rubygems.org'

gem 'rails', '3.2.17'

gem 'jquery-rails', '2.3.0'
gem 'squeel'

gem 'lev', "~> 2.0.4"

# gem 'jbuilder'
gem 'whenever', :require => false
gem 'newrelic_rpm'
gem 'yaml_db'

gem 'nested_form'

gem 'carrierwave'
gem 'mini_magick'
gem 'parslet', '~> 1.5'

gem 'will_paginate', '~> 3.0'
gem 'acts-as-taggable-on'
gem 'acts_as_votable'
gem 'deep_cloneable'
gem 'remotipart', '~> 1.2'

gem 'commontator', '~> 4.2.0'
gem 'fine_print', '~> 1.2.0'
gem 'openstax_connect', git: 'https://github.com/Dantemss/connect-rails',
                        ref: '5f17c363a33d7c8973796469f0f5c4328831ac2b'
gem 'openstax_utilities', git: 'https://github.com/Dantemss/openstax_utilities',
                          ref: '1e595556dac27b5d71b180bf45cf36ff1845f3b5'
gem 'openstax_api', '~> 0.1.0'

# API documentation
gem 'apipie-rails', '~> 0.1.1'
gem 'maruku'
gem 'representable', git: 'git://github.com/jpslav/representable.git', ref: '0b8ba7a2e7a6ce0bc404fe5af9ead26295db1457'
# see https://groups.google.com/d/msg/roar-talk/KI-a5t02huc/RKwkcZ5SzOEJ
# gem 'roar', git: 'git://github.com/andresf/roar.git', ref: '0698cb17515ae229bd10580a95062530aba4f583'
gem 'roar-rails'

gem 'doorkeeper', '~> 0.6.7'
gem 'exception_notification'

gem 'ejs'
gem 'eco'

gem 'tinymce-rails', git: 'git://github.com/spohlenz/tinymce-rails.git', branch: 'tinymce-4'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',     '~> 3.2.3'
  gem 'coffee-rails',   '~> 3.2.1'
  gem 'bootstrap-sass', '~> 3.0.2.0'
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails'
end

group :development, :test do
  gem 'rails-erd'
  gem 'sqlite3', '~> 1.3.6'
  gem 'debugger', '~> 1.5.0'
  gem 'quiet_assets'
  gem 'timecop'
  gem 'rspec-rails'
  gem 'capybara', '<2.1.0'  ## see: https://github.com/thoughtbot/capybara-webkit/issues/507
  gem 'capybara-screenshot'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'faker'
  gem 'thin'
  gem 'cheat'
  gem 'brakeman'
  gem 'railroady'
  gem 'rspec-rerun'
  gem 'cucumber-rails', :require => false
  gem 'nifty-generators'
  gem 'rack-test', require: "rack/test"
  gem 'factory_girl_rails'
  gem 'coffee-rails-source-maps'
end

group :production do
  gem 'mysql2', '~> 0.3.11'
end
