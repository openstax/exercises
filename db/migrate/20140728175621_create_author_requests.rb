class CreateAuthorRequests < ActiveRecord::Migration
  def change
    create_table :author_requests do |t|
      t.references :requestor, null: false
      t.references :collaborator, null: false

      t.timestamps
    end

    add_index :author_requests, :collaborator_id, unique: true
    add_index :author_requests, :requestor_id
  end
end
