class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.references :account, null: false
      t.references :default_list, null: false
      t.datetime :registered_at
      t.datetime :disabled_at
      t.boolean :subscribe_on_comment, null: false, default: false
      t.boolean :send_emails, null: false, default: true
      t.boolean :collaborator_request_email, null: false, default: true
      t.boolean :permission_email, null: false, default: true

      t.timestamps
    end

    add_index :users, :account_id, unique: true
    add_index :users, :default_list_id
    add_index :users, :registered_at
    add_index :users, :disabled_at
  end
end
