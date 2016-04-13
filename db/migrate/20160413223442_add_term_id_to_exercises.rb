class AddTermIdToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :term_id, :integer

    add_index :exercises, :term_id
  end
end
