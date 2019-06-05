class CreateCopyrightHolders < ActiveRecord::Migration[4.2]
  def change
    create_table :copyright_holders do |t|
      t.sortable
      t.references :publication, null: false
      t.references :user, null: false

      t.timestamps null: false
    end

    add_sortable_index :copyright_holders, scope: :publication_id
    add_index :copyright_holders, [:user_id, :publication_id], unique: true
  end
end
