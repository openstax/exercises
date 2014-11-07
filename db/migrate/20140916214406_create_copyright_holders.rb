class CreateCopyrightHolders < ActiveRecord::Migration
  def change
    create_table :copyright_holders do |t|
      t.references :publication, null: false
      t.references :user, null: false

      t.timestamps null: false
    end

    add_index :copyright_holders, [:publication_id, :user_id], unique: true
    add_index :copyright_holders, :user_id
  end
end
