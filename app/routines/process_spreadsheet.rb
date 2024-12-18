class ProcessSpreadsheet
  lev_routine

  protected

  def exec(filename:, offset: 1, pad_cells: true, headers: false, &block)
    raise ArgumentError, 'A block must be provided' if block.nil?

    if File.extname(filename) == 'csv'
      klass = Roo::CSV
      method = :each_row
    else
      klass = Roo::Excelx
      method = :each_row_streaming
    end

    args = []
    pad_to_size = 0 if pad_cells
    klass.new(filename).public_send(method).each_with_index do |row, row_index|
      if headers && row_index == 0
        header_row = row.map { |header| header.to_s || '' }
        header_row = header_row.map { |header| header.send(headers) } if [String, Symbol].include?(headers.class)
        args << header_row
      elsif pad_cells
        row += [nil] * (pad_to_size - row.length) if pad_to_size > row.length
        pad_to_size = row.length
      end

      block.call(*(args + [row, row_index])) if row_index >= offset
    end
  end
end
