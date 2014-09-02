class CreateFormats < ActiveRecord::Migration
  def change
    create_table :formats do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end

    add_index :formats, :name, unique: true
  end
end
