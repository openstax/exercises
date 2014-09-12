class CreateFormats < ActiveRecord::Migration
  def change
    create_table :formats do |t|
      t.string :name, null: false
      t.string :title, null: false
      t.text :description

      t.timestamps
    end

    add_index :formats, :name, unique: true
    add_index :formats, :title, unique: true
  end
end
