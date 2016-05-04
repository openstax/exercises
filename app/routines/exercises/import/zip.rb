# Imports a zip file containing Exercises
# The zip file should contain an Excel spreadsheet and, optionally, image files

module Exercises
  module Import
    class Zip

      lev_routine

      uses_routine Exercises::Import::Xlsx,
                   as: :import_xlsx,
                   translations: { outputs: { type: :verbatim } }

      # Imports Exercises from a zip file
      def exec(filename: 'exercises.zip',
               author_id: Exercises::Import::Xlsx::DEFAULT_AUTHOR_ID,
               ch_id: Exercises::Import::Xlsx::DEFAULT_CH_ID,
               skip_first_row: true)
        # Create a temp directory and extract the zip file into it
        zip_path = File.expand_path(filename)
        Dir.mktmpdir do |dir|
          Dir.chdir(dir) do
            ::Zip::File.open(zip_path) do |zip_file|
              zip_file.each do |entry|
                entry.extract(entry.name)
              end
            end

            # Import the first spreadsheet found in the temp directory
            xlsx_filename = Dir.glob('*.xlsx').first

            run(:import_xlsx,
                filename: xlsx_filename,
                author_id: author_id,
                ch_id: ch_id,
                skip_first_row: skip_first_row)
          end
        end
      end

    end
  end
end
