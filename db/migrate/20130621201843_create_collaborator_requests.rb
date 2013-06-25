class CreateCollaboratorRequests < ActiveRecord::Migration
  def change
    create_table :collaborator_requests do |t|
      t.integer :collaborator_id
      t.integer :requester_id
      t.boolean :toggle_author
      t.boolean :toggle_copyright_holder

      t.timestamps
    end

    add_index :collaborator_requests, [:collaborator_id, :toggle_author], :unique => true, :name => "index_c_r_on_c_id_and_toggle_author"
    add_index :collaborator_requests, [:collaborator_id, :toggle_copyright_holder], :unique => true, :name => "index_c_r_on_c_id_and_toggle_copyright_holder"
  end
end
