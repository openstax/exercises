class DropEditors < ActiveRecord::Migration[4.2]
  def change
    drop_table :editors
  end
end
