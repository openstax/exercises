class CreateCopyrightHolderRequests < ActiveRecord::Migration
  def change
    create_table :copyright_holder_requests do |t|
      t.references :requestor, null: false
      t.references :collaborator, null: false

      t.timestamps
    end

    add_index :copyright_holder_requests, :collaborator_id, unique: true
    add_index :copyright_holder_requests, :requestor_id
  end
end
