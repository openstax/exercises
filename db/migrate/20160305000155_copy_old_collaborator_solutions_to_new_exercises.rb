class CopyOldCollaboratorSolutionsToNewExercises < ActiveRecord::Migration
  def up
    Exercise.preload([:publication, {questions: :collaborator_solutions}])
            .to_a.group_by(&:number).each do |number, exercises|
      exercises_with_sols = exercises.select{ |ex| ex.questions.first.collaborator_solutions.any? }
      next if exercises_with_sols.empty?

      newest_ex_with_sol = exercises_with_sols.max_by(&:version)
      newer_exercises = exercises.select{ |ex| ex.version > newest_ex_with_sol.version }
      next if newer_exercises.empty?

      newest_sol = newest_ex_with_sol.questions.first.collaborator_solutions.first

      newer_exercises.each do |exercise|
        exercise.questions.first.collaborator_solutions.create!(
          title: newest_sol.title,
          solution_type: newest_sol.solution_type,
          content: newest_sol.content
        )
      end
    end
  end

  def down
  end
end
