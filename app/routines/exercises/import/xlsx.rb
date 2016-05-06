# Imports an xlsx file containing Exercises

module Exercises
  module Import
    class Xlsx

      lev_routine

      include ::Import::ExerciseImporter
      include ::Import::XlsxImporter

    end

  end
end
