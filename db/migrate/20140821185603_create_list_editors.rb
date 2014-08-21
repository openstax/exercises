class CreateListEditors < ActiveRecord::Migration
  def change
    create_table :list_editors do |t|
      t.references :list
      t.references :editor, polymorphic: true

      t.timestamps
    end

    add_index :list_editors, [:editor_id, :editor_type, :list_id], unique: true
    add_index :list_editors, :list_id
  end
end
