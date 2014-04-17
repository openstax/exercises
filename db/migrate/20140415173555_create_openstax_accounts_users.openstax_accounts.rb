# This migration comes from openstax_accounts (originally 0)
class CreateOpenStaxAccountsUsers < ActiveRecord::Migration
  def change
    create_table :openstax_accounts_users do |t|
      t.integer :openstax_uid
      t.string  :username
      t.string  :first_name
      t.string  :last_name
      t.string  :full_name
      t.string  :title
      t.string  :access_token

      t.timestamps
    end

    add_index :openstax_accounts_users, :openstax_uid, :unique => true
    add_index :openstax_accounts_users, :username, :unique => true
  end
end
