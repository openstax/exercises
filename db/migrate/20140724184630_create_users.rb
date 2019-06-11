class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.references :account, null: false

      t.datetime :deleted_at

      t.boolean :show_public_domain_attribution, null: false, default: true
      t.boolean :forward_notifications_to_deputies, null: false, default: false
      t.boolean :receive_role_notifications, null: false, default: true
      t.boolean :receive_access_notifications, null: false, default: true
      t.boolean :receive_comment_notifications, null: false, default: true

      t.timestamps null: false
    end

    add_index :users, :account_id, unique: true
    add_index :users, :deleted_at
  end
end
