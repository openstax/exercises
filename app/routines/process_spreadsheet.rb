class ProcessSpreadsheet
  lev_routine

  protected

  # "headers" can be either false to disable headers,
  # or a method name to normalize the headers, like :downcase
  def exec(filename:, offset: 1, pad_cells: true, headers: false, &block)
    raise ArgumentError, 'A block must be provided' if block.nil?

    if File.extname(filename) == '.csv'
      klass = Roo::CSV
      method = :each
    else
      klass = Roo::Excelx
      method = :each_row_streaming
    end

    args = []
    pad_to_size = 0 if pad_cells
    klass.new(filename).public_send(method).each_with_index do |row, row_index|
      normalized_row = row.map { |value| value&.to_s&.strip }

      if headers && row_index == 0
        header_row = normalized_row
        header_row = header_row.map do |header|
          header.send(headers) unless header.nil?
        end if [String, Symbol].include?(headers.class)
        args << header_row
      elsif pad_cells
        normalized_row += [nil] * (pad_to_size - row.length) if pad_to_size > row.length
        pad_to_size = row.length
      end

      block.call(*(args + [normalized_row, row_index])) if row_index >= offset
    end
  end
end
