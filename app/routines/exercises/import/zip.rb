# Imports a zip file
# The zip file should an Excel spreadsheet and, optionally, image files
# Arguments are, in order:
# zip_filename, excel_filename (in the zip file),
# author's user id, copyright holder's user id, skip_first_row

module Exercises
  module Import
    class Zip

      lev_routine

      uses_routine Exercises::Import::Excel,
                   as: :import_spreadsheet,
                   translations: { outputs: { type: :verbatim } }

      # Imports Exercises from a zip file
      def exec(zip_filename: 'exercises.zip',
               excel_filename: 'exercises.xlsx',
               author_id: Exercises::Import::Excel::DEFAULT_AUTHOR_ID,
               ch_id: Exercises::Import::Excel::DEFAULT_CH_ID,
               skip_first_row: true)
        # Create a temp directory and extract the zip file into it
        zip_path = File.expand_path(zip_filename)
        Dir.mktmpdir do |dir|
          Dir.chdir(dir) do
            ::Zip::File.open(zip_path) do |zip_file|
              zip_file.each do |entry|
                entry.extract(entry.name)
              end
            end

            # Import the spreadsheet from the temp directory
            run(:import_spreadsheet,
                filename: excel_filename,
                author_id: author_id,
                ch_id: ch_id,
                skip_first_row: skip_first_row)
          end
        end
      end

    end

  end
end
