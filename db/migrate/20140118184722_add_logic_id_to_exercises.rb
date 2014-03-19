class AddLogicIdToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :logic_id, :integer
    add_index :exercises, :logic_id, unique: true
  end
end
