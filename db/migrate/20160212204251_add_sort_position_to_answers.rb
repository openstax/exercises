class AddSortPositionToAnswers < ActiveRecord::Migration
  def change
    add_sortable_column :answers, null: true

    # Make each exercise's answers have the same sort_position as the first imported version
    reversible do |dir|
      dir.up do
        Exercise.preload([:publication, {questions: :answers}])
                .group_by(&:number).each do |number, exercises|
          answer_position = {}
          exercises.sort_by(&:version).each do |exercise|
            exercise.questions.each do |question|
              positions = []
              question.answers.sort_by(&:id).each_with_index do |answer, index|
                content = answer.content.downcase.strip
                position = answer_position[content] || index + 1
                position += 1 while positions.include?(position)
                answer.update_attribute(:sort_position, position)
                answer_position[content] = position
                positions << position
              end
            end
          end
        end
      end
    end

    change_column_null :answers, :sort_position, false
    add_sortable_index :answers, scope: :question_id
  end
end
