ENV['RAILS_ENV'] = 'test'

require 'simplecov_helper'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'shoulda/matchers'
require 'spec_helper'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |file| require file }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include CaptureStdoutHelper
  config.include AccountsHelper, type: :request

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  config.prepend_before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.prepend_before(:all) do
    metadata = self.class.metadata
    DatabaseCleaner.strategy = metadata[:js] || metadata[:truncation] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.prepend_before(:each) do
    DatabaseCleaner.start
  end

  # https://github.com/DatabaseCleaner/database_cleaner#rspec-with-capybara-example says:
  #   "It's also recommended to use append_after to ensure DatabaseCleaner.clean
  #    runs after the after-test cleanup capybara/rspec installs."
  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  config.append_after(:all) do
    DatabaseCleaner.clean
  end
end

"""
  Config for Shoulda Matchers
"""
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Adds a convenience method to get interpret the body as JSON and convert to a hash;
# works for both request and controller specs
class ActionDispatch::TestResponse
  def body_as_hash
    @body_as_hash_cache ||= JSON.parse(body, symbolize_names: true)
  end
end
