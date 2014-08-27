class CreateCollaborators < ActiveRecord::Migration
  def change
    create_table :collaborators do |t|
      t.sortable
      t.references :collaborable, polymorphic: true, null: false
      t.references :user, null: false
      t.boolean :is_author, null: false, default: false
      t.boolean :is_copyright_holder, null: false, default: false

      t.timestamps
    end

    add_sortable_index :collaborators, [:collaborable_id, :collaborable_type],
              name: 'index_collaborators_on_c_id_and_c_type_and_sortable_position'
    add_index :collaborators, [:user_id, :collaborable_id, :collaborable_type],
              unique: true, name: 'index_collaborators_on_u_id_and_c_id_and_c_type'
  end
end
