class MoveExerciseCredit < ActiveRecord::Migration
  def up
    remove_column :exercises, :credit
    add_column :list_exercises, :credit, :float
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
