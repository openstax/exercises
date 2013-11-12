class SwitchToContentModel < ActiveRecord::Migration
  def up
    remove_column :exercises, :content
    remove_column :exercises, :content_html

    add_column :exercises, :background_id, :integer
    add_index :exercises, :background_id

    remove_column :questions, :content
    remove_column :questions, :content_html

    remove_column :solutions, :content
    remove_column :solutions, :content_html

    add_column :solutions, :content_id, :integer
    add_index :solutions, :content_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
