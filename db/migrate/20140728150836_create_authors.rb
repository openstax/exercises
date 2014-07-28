class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.sortable
      t.references :publishable, polymorphic: true, null: false
      t.references :user, null: false

      t.timestamps
    end

    add_index :authors, [:publishable_id, :publishable_type, :position], unique: true,
              name: "index_authors_on_p_id_and_p_type_and_position"
    add_index :authors, [:user_id, :publishable_id, :publishable_type], unique: true,
              name: "index_authors_on_u_id_and_p_id_and_p_type"
  end
end
