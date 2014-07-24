class BetterSolutionContent < ActiveRecord::Migration
  def up
    remove_index :solutions, :content_id
    remove_column :solutions, :content_id

    add_column :solutions, :details_id, :integer
    add_index :solutions, :details_id

    add_column :solutions, :summary_id, :integer
    add_index :solutions, :summary_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
