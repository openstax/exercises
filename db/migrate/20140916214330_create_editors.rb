class CreateEditors < ActiveRecord::Migration
  def change
    create_table :editors do |t|
      t.references :publication, null: false
      t.references :user, null: false

      t.timestamps
    end

    add_index :editors, [:publication_id, :user_id], unique: true
    add_index :editors, :user_id
  end
end
