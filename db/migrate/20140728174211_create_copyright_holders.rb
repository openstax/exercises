class CreateCopyrightHolders < ActiveRecord::Migration
  def change
    create_table :copyright_holders do |t|
      t.sortable
      t.references :publishable, polymorphic: true, null: false
      t.references :user, null: false

      t.timestamps
    end

    add_index :copyright_holders, [:publishable_id, :publishable_type, :position],
              unique: true, name: "index_copyright_holders_on_p_id_and_p_type_and_position"
    add_index :copyright_holders, [:user_id, :publishable_id, :publishable_type],
              unique: true, name: "index_copyright_holders_on_u_id_and_p_id_and_p_type"
  end
end
