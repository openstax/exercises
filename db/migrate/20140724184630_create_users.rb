class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.references :account, null: false
      t.datetime :registered_at

      t.boolean :hide_public_domain_attribution, null: false, default: false
      t.boolean :subscribe_on_comment, null: false, default: false
      t.boolean :send_emails, null: false, default: true
      t.boolean :collaborator_request_email, null: false, default: true
      t.boolean :permission_change_email, null: false, default: true

      t.timestamps
    end

    add_index :users, :account_id, unique: true
    add_index :users, :registered_at
  end
end
