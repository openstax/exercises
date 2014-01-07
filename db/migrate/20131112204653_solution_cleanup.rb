class SolutionCleanup < ActiveRecord::Migration
  def up
    remove_column :solutions, :summary
    remove_column :solutions, :summary_html
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
