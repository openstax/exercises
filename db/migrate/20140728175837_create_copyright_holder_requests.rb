class CreateCopyrightHolderRequests < ActiveRecord::Migration
  def change
    create_table :copyright_holder_requests do |t|
      t.references :publishable, polymorphic: true, null: false
      t.references :user, null: false

      t.timestamps
    end

    add_index :copyright_holder_requests, [:publishable_id, :publishable_type, :user_id],
              unique: true, name: "index_copyright_holder_requests_on_p_id_and_p_type_and_u_id"
    add_index :copyright_holder_requests, :user_id
  end
end
