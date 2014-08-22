class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.references :account, null: false

      t.boolean :show_public_domain_attribution, null: false, default: true
      t.boolean :forward_emails_to_deputies, null: false, default: false
      t.boolean :receive_emails, null: false, default: true
      t.boolean :receive_collaborator_emails, null: false, default: true
      t.boolean :receive_list_emails, null: false, default: true
      t.boolean :receive_comment_emails, null: false, default: false

      t.timestamps
    end

    add_index :users, :account_id, unique: true
  end
end
