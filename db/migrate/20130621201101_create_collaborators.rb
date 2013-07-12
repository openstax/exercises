class CreateCollaborators < ActiveRecord::Migration
  def change
    create_table :collaborators do |t|
      t.integer :position, :null => false
      t.string :publishable_type, :null => false
      t.integer :publishable_id, :null => false
      t.integer :user_id, :null => false
      t.boolean :is_author, :null => false, :default => false
      t.boolean :is_copyright_holder, :null => false, :default => false
      t.boolean :toggle_author_request, :null => false, :default => false
      t.boolean :toggle_copyright_holder_request, :null => false, :default => false

      t.timestamps
    end

    add_index :collaborators, [:publishable_type, :publishable_id, :user_id], :unique => true, :name => "index_c_on_p_type_and_p_id_and_u_id"
    add_index :collaborators, :position
    add_index :collaborators, :user_id
  end
end
