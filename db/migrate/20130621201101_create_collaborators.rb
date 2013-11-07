class CreateCollaborators < ActiveRecord::Migration
  def change
    create_table :collaborators do |t|
      t.sortable
      t.belongs_to :publishable, polymorphic: true, null: false
      t.belongs_to :user, null: false
      t.boolean :is_author, null: false, default: false
      t.boolean :is_copyright_holder, null: false, default: false
      t.boolean :toggle_author_request, null: false, default: false
      t.boolean :toggle_copyright_holder_request, null: false, default: false

      t.timestamps
    end

    add_index :collaborators, [:publishable_type, :publishable_id, :position], unique: true, name: "index_c_on_p_type_and_p_id_and_position"
    add_index :collaborators, [:user_id, :publishable_type, :publishable_id], unique: true, name: "index_c_on_u_id_and_p_type_and_p_id"
  end
end
