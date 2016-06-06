# Imports an xlsx file containing VocabTerms

module VocabTerms
  module Import
    class Xlsx

      lev_routine

      include ::Xlsx::Importer
      include VocabTerms::Importer

    end

  end
end
