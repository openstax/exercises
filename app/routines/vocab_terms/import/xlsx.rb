# Imports an xlsx file containing VocabTerms

module VocabTerms
  module Import
    class Xlsx

      lev_routine

      include ::Import::VocabTermImporter
      include ::Import::XlsxImporter

    end

  end
end
