class CreateWebsiteConfigurations < ActiveRecord::Migration
  def change
    create_table :website_configurations do |t|
      t.string :name
      t.string :value
      t.integer :value_type

      t.timestamps
    end

    add_index :website_configurations, :name, :unique => true
  end
end
