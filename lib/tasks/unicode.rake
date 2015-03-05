# Imports a unicode tab-delimited txt file saved from Excel
# Arguments are, in order:
# filename, author's user id, copyright holder's user id,
# skip_first_row, column separator and row separator
# Example: rake exercises:import:unicode[exercises.txt,1,2]
#          will import exercises from exercises.txt and
#          assign the user with ID 1 as the author and
#          solution author, and the user with ID 2 as the CR holder

namespace :exercises do
  namespace :import do
    task :unicode, [:filename, :author_id, :ch_id, :skip_first_row,
                    :col_sep, :row_sep] => :environment do |t, args|
      Exercises::Import::Unicode.call(args)
    end
  end
end
