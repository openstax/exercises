# Imports a file containing Publishables
module Publishable
  module Importer

    DEFAULT_AUTHOR_ID = 1
    DEFAULT_CH_ID = 2

    attr_reader :author, :copyright_holder

    def exec(filename:,
             author_id: DEFAULT_AUTHOR_ID,
             ch_id: DEFAULT_CH_ID,
             skip_first_row: true)
      Rails.logger.info { "Reading from #{filename}." }

      @author = User.find_by(id: author_id)
      @copyright_holder = User.find_by(id: ch_id)

      Rails.logger.info { "Setting #{author.full_name} as Author" }
      Rails.logger.info { "Setting #{copyright_holder.full_name} as Copyright Holder" }

      import_file(filename, skip_first_row)
    end

  end
end
