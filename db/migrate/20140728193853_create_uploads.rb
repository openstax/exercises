class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.references :publishable, polymorphic: true, null: false
      t.string :asset, null: false

      t.timestamps
    end

    add_index :uploads, :asset, unique: true
  end
end
