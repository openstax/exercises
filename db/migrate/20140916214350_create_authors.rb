class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.references :publication, null: false
      t.references :user, null: false

      t.timestamps null: false
    end

    add_index :authors, [:publication_id, :user_id], unique: true
    add_index :authors, :user_id
  end
end
