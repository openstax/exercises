OpenStax::Accounts::Account.reset_column_information

# Output logging info to stdout
original_logger = Rails.logger
begin
  Rails.logger = ActiveSupport::Logger.new(STDOUT)

  CreateDefaultCollaborators.call
ensure
  # Restore original logger
  Rails.logger = original_logger
end
