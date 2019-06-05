class CreateListEditors < ActiveRecord::Migration[4.2]
  def change
    create_table :list_editors do |t|
      t.references :editor, polymorphic: true, null: false
      t.references :list, null: false

      t.timestamps null: false
    end

    add_index :list_editors, [:editor_id, :editor_type, :list_id], unique: true
    add_index :list_editors, :list_id
  end
end
