class FindInvalidExercises
  MIN_ALT_TEXT_LENGTH = 20
  MAX_RESULTS = 100

  lev_routine express_output: :exercises

  protected

  def exec
    outputs.exercises = []
    Exercise.where("\"exercises\".\"context\" ILIKE '%<img%'").or(
      Exercise.where("\"exercises\".\"stimulus\" ILIKE '%<img%'")
    ).or(
      Exercise.where(
        Question.where('"questions"."exercise_id" = "exercises"."id"').where(
          "\"questions\".\"stimulus\" ILIKE '%<img%'"
        ).arel.exists
      )
    ).or(
      Exercise.where(
        Stem.joins(:question).where('"questions"."exercise_id" = "exercises"."id"').where(
          "\"stems\".\"content\" ILIKE '%<img%'"
        ).arel.exists
      )
    ).or(
      Exercise.where(
        Answer.joins(:question).where('"questions"."exercise_id" = "exercises"."id"').where(
          "\"answers\".\"content\" ILIKE '%<img%'"
        ).arel.exists
      )
    ).latest.preload(questions: { stems: { stem_answers: :answer } }).find_each do |exercise|
      fragment = Nokogiri::HTML.fragment exercise.flattened_content
      outputs.exercises << exercise if fragment.css('img').any? do |node|
        node['alt'].nil? || node['alt'].length < MIN_ALT_TEXT_LENGTH
      end

      break if outputs.exercises.size >= MAX_RESULTS
    end
  end
end
