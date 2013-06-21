class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.string :short_name
      t.string :long_name
      t.string :url
      t.string :partial_name
      t.boolean :is_default

      t.timestamps
    end
  end
end
