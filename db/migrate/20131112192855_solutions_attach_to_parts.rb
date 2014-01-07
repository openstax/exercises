class SolutionsAttachToParts < ActiveRecord::Migration
  def up
    remove_index :solutions, :exercise_id
    remove_column :solutions, :exercise_id

    add_column :solutions, :part_id, :integer
    add_index :solutions, :part_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
