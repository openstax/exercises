# Imports an Excel file

# Reads xlxs
require 'roo'

module Exercises
  module Import
    class Old::Excel < Old::RowImporter

      lev_routine

      # Imports Exercises from a spreadsheet
      def exec(filename: 'exercises.xlsx',
               author_id: DEFAULT_AUTHOR_ID,
               ch_id: DEFAULT_CH_ID,
               skip_first_row: true)

        Rails.logger.info "Reading from #{filename}."

        @author = User.find_by(id: author_id)
        @copyright_holder = User.find_by(id: ch_id)
        @skip_first_row = skip_first_row

        Rails.logger.info "Setting #{@author.full_name} as Author"
        Rails.logger.info "Setting #{@copyright_holder.full_name} as Copyright Holder"

        import(filename)
      end

      def import(filename)
        book = Roo::Excelx.new(filename)
        record_failures do
          book.each_row_streaming(offset: skip_first_row ? 1 : 0, pad_cells: true)
              .each_with_index do |row, index|
            values = 0.upto(row.size-1).collect do |index|
              # Hack until Roo's new version with proper typecasting is released
              val = row[index].try(:value)
              Integer(val) rescue val
            end
            next if values.compact.blank?
            import_row(values, index)
          end
        end
      end

    end

  end
end
