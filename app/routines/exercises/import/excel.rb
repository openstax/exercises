# Imports a XLXS file from Excel
# Arguments are, in order:
# filename, author's user id, copyright holder's user id, skip_first_row

# Reads xls format
require 'spreadsheet'

# Reads xlxs
require 'rubyXL'

module Exercises
  module Import
    class Excel < RowImporter

      lev_routine

      # Imports Exercises from a unicode spreadsheet
      def exec(filename: 'exercises.xlsx',
               author_id: DEFAULT_AUTHOR_ID,
               ch_id: DEFAULT_CH_ID,
               skip_first_row: true)

        puts "Reading from #{filename}."

        @author = User.find_by(id: author_id)
        @copyright_holder = User.find_by(id: ch_id)
        @skip_first_row = skip_first_row

        puts "Setting #{@author.full_name} as Author"
        puts "Setting #{@copyright_holder.full_name} as Copyright Holder"

        ext = File.extname(filename)
        if ext == '.xlsx'
          import_from_xlsx(filename)
        elsif ext == '.xls'
          import_from_xls(filename)
        end
      end

      def import_from_xls(filename)
        book = Spreadsheet.open(filename)
        sheet = book.worksheet(0)
        record_failures do
          sheet.each_with_index do |row, index|
            next if index == 0 && skip_first_row
            import_row(row,index)
          end
        end
      end


      def import_from_xlsx(filename)
        book = RubyXL::Parser.parse(filename)
        sheet = book.worksheets[0]
        record_failures do
          sheet.each_with_index do |row, index|
            next if index == 0 && skip_first_row
            values = []
            0.upto(row.size-1).each do |index|
              values << row[index].value
            end
            import_row(values, index)
          end
        end
      end

    end

  end
end
