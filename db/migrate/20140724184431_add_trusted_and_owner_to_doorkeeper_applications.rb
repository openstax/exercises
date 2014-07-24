class AddTrustedAndOwnerToDoorkeeperApplications < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :trusted, :boolean, :null => false, :default => false
    add_column :oauth_applications, :owner_id, :integer
    add_column :oauth_applications, :owner_type, :string

    add_index :oauth_applications, [:owner_id, :owner_type]
  end
end
