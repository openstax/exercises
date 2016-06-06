# Imports an xlsx file containing Exercises

module Exercises
  module Import
    class Xlsx

      lev_routine

      include ::Xlsx::Importer
      include Exercises::Importer

    end

  end
end
