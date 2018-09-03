require 'a15k/html_preview'
require 'yaml'

namespace :a15k do
  desc "export exercise to a15k"
  task :export, [] => [:environment] do

    # Run it!

    outcomes = A15k::Exporter.new.run

    # Report on outcomes

    success_count = outcomes[:success_count]
    failure_count = outcomes[:failures].length
    total_count = success_count + failure_count

    puts "Exported #{success_count} of #{total_count} exercises to A15k.\n"

    if outcomes[:failures].any?
      puts "Failure info:\n"
      outcomes[:failures].each do |failure|
        puts "  uid: #{failure[:uid]}, message: #{failure[:message]}"
      end
    end

  end
end
