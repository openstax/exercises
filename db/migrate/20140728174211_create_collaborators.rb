class CreateCollaborators < ActiveRecord::Migration
  def change
    create_table :collaborators do |t|
      t.sortable
      t.references :parent, polymorphic: true, null: false
      t.references :user, null: false
      t.boolean :is_author, null: false, default: false
      t.boolean :is_copyright_holder, null: false, default: false

      t.timestamps
    end

    add_sortable_index :collaborators, [:parent_id, :parent_type],
              name: 'index_collaborators_on_p_id_and_p_type_and_sortable_position'
    add_index :collaborators, [:user_id, :parent_id, :parent_type], unique: true
  end
end
