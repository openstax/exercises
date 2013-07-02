class CreateCollaborators < ActiveRecord::Migration
  def change
    create_table :collaborators do |t|
      t.integer :user_id, :null => false
      t.integer :collaborable_id, :null => false
      t.string :collaborable_type, :null => false
      t.integer :number, :null => false
      t.boolean :is_author, :null => false, :default => false
      t.boolean :is_copyright_holder, :null => false, :default => false
      t.boolean :toggle_author_request, :null => false, :default => false
      t.boolean :toggle_copyright_holder_request, :null => false, :default => false
      t.integer :requester_id, :null => false

      t.timestamps
    end

    add_index :collaborators, [:collaborable_type, :collaborable_id, :user_id], :unique => true, :name => "index_c_on_c_type_and_c_id_and_u_id"
    add_index :collaborators, :user_id
    add_index :collaborators, :is_author
    add_index :collaborators, :is_copyright_holder
  end
end
