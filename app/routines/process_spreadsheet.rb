class ProcessSpreadsheet
  lev_routine

  protected

  def exec(filename:, offset:, pad_cells: true, &block)
    raise ArgumentError, 'A block must be provided' if block.nil?

    if File.extname(filename) == 'csv'
      klass = Roo::CSV
      method = :each_row
    else
      klass = Roo::Excelx
      method = :each_row_streaming
    end

    pad_to_size = 0 if pad_cells
    klass.new(filename).public_send(method).each_with_index do |row, row_index|
      if pad_cells
        row += [nil] * (pad_to_size - row.length) if pad_to_size > row.length
        pad_to_size = row.length
      end

      block.call(row, row_index) if row_index >= offset
    end
  end
end
