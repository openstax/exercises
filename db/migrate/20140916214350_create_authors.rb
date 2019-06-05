class CreateAuthors < ActiveRecord::Migration[4.2]
  def change
    create_table :authors do |t|
      t.sortable
      t.references :publication, null: false
      t.references :user, null: false

      t.timestamps null: false
    end

    add_sortable_index :authors, scope: :publication_id
    add_index :authors, [:user_id, :publication_id], unique: true
  end
end
