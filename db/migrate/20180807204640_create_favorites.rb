class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :publication, null: false
      t.references :user, null: false

      t.timestamps null: false
    end

    add_index :favorites, [:user_id, :publication_id], unique: true
  end
end
