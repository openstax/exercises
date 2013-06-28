class CreateCollaboratorRequests < ActiveRecord::Migration
  def change
    create_table :collaborator_requests do |t|
      t.integer :collaborator_id, :null => false
      t.integer :requester_id, :null => false
      t.boolean :toggle_author, :null => false, :default => false
      t.boolean :toggle_copyright_holder, :null => false, :default => false

      t.timestamps
    end

    add_index :collaborator_requests, :collaborator_id, :unique => true
  end
end
