class DropEditors < ActiveRecord::Migration
  def change
    drop_table :editors
  end
end
