class AddTrustedToApplication < ActiveRecord::Migration
  def change
    add_column :oauth_applications, :trusted, :boolean, null: false, default: false
  end
end
