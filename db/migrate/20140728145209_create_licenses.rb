class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.string :name, null: false
      t.string :title, null: false
      t.string :url, null: false
      t.text :publishing_contract, null: false
      t.text :copyright_notice, null: false
      t.boolean :requires_attribution, null: false, default: true
      t.boolean :share_alike, null: false, default: false
      t.boolean :no_derivatives, null: false, default: false
      t.boolean :non_commercial, null: false, default: false

      t.timestamps
    end

    add_index :licenses, :name, unique: true
    add_index :licenses, :title, unique: true
    add_index :licenses, :url, unique: true
  end
end
