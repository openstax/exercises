class AddMissingPositionIndices < ActiveRecord::Migration
  def up
    add_index :questions, [:part_id, :position], unique: true
    add_index :parts, [:exercise_id, :position], unique: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
