# This migration comes from openstax_connect (originally 20130729213800)
class CreateOpenStaxConnectUsers < ActiveRecord::Migration
  def change
    create_table :openstax_connect_users do |t|
      t.integer :openstax_uid
      t.string  :first_name
      t.string  :last_name
      t.string  :username

      t.timestamps
    end

    add_index :openstax_connect_users, :openstax_uid, :unique => true
    add_index :openstax_connect_users, :username, :unique => true
  end
end
