namespace :exercises do
  namespace :tag do

    desc "add a module to exercises that are tagged with another module"
    task :import_from_module_map, [:file] => :environment do |t, args|
      Tag.transaction do
        CSV.foreach(args[:file]) do |src_uuid, new_uuid|
          src = Tag.where(name: "context-cnxmod:#{src_uuid}").first
          next unless src

          new_tag = Tag.find_or_create_by(name: "context-cnxmod:#{new_uuid}")
          src.exercise_tags.each do |et|
            exercise = et.exercise
            unless exercise.exercise_tags.where(tag_id: new_tag.id).exists?
              exercise.exercise_tags.create!(tag: new_tag)
              exercise.touch
            end
          end
        end
      end
    end

    # Tags exercises using a spreadsheet
    # Arguments are, in order:
    # filename, [skip_first_row]
    # Example: rake exercises:tag:xlsx[tags.xlsx]
    #          will tag exercises based on tags.xlsx
    desc "tags exercises using an xlsx file"
    task :xlsx, [:filename, :skip_first_row] => :environment do |t, args|
      # Output import logging info to the console (except in the test environment)
      original_logger = Rails.logger

      begin
        Rails.logger = ActiveSupport::Logger.new(STDOUT) unless Rails.env.test?

        Exercises::Tag::Xlsx.call(args.to_h)
      ensure
        # Restore original logger
        Rails.logger = original_logger
      end
    end
  end
end
