# Imports an xlsx file
module Import
  module XlsxImporter

    include RowParser

    def import_file(filename, skip_first_row)
      book = Roo::Excelx.new(filename)
      row_offset = skip_first_row ? 1 : 0

      record_failures do |failures|
        book.each_row_streaming(offset: row_offset, pad_cells: true)
            .each_with_index do |row, index|
          values = 0.upto(row.size - 1).map do |index|
            # Hack until Roo's new version with proper typecasting is released
            val = row[index].try(:value)
            Integer(val) rescue val.try(:to_s)
          end
          next if values.compact.blank?

          row_number = index + row_offset + 1

          begin
            import_row(values, row_number)
          rescue StandardError => se
            Rails.logger.error "Failed to import row ##{row_number} - #{se.message}"
            failures[row_number] = se.to_s
          end
        end
      end
    end

  end
end
