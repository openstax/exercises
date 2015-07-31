class AddCreatedAtIndexToExercises < ActiveRecord::Migration
  def change
    add_index :exercises, :created_at
  end
end
