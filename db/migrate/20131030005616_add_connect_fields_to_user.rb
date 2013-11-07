class AddConnectFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :openstax_connect_user_id, :integer
    add_index :users, :openstax_connect_user_id, :unique => true
  end
end
