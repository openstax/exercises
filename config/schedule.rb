# Learn more: http://github.com/javan/whenever

bundle_command = ENV['BUNDLE_COMMAND'] || 'bundle exec'

set :bundle_command, bundle_command
set :runner_command, "#{bundle_command} rails runner"

# Server time is UTC; times below are interpreted that way.
# Ideally we'd have a better way to specify times relative to Central
# time, independent of the server time.  Maybe there's something here:
#   * https://github.com/javan/whenever/issues/481
#   * https://github.com/javan/whenever/pull/239

# Add this in once a15k is stable
# every 1.day do
#   rake "a15k:export"
# end
