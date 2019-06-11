class CreateEditors < ActiveRecord::Migration[4.2]
  def change
    create_table :editors do |t|
      t.sortable
      t.references :publication, null: false
      t.references :user, null: false

      t.timestamps null: false
    end

    add_sortable_index :editors, scope: :publication_id
    add_index :editors, [:user_id, :publication_id], unique: true
  end
end
