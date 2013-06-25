class CreateCollaboratorRequests < ActiveRecord::Migration
  def change
    create_table :collaborator_requests do |t|
      t.integer :collaborator_id
      t.integer :requester_id
      t.boolean :toggle_author
      t.boolean :toggle_copyright_holder

      t.timestamps
    end

    add_index :collaborator_requests, :collaborator_id, :unique => true
  end
end
