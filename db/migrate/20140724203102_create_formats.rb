class CreateFormats < ActiveRecord::Migration
  def change
    create_table :formats do |t|
      t.sortable
      t.string :name, null: false

      t.timestamps
    end

    add_index :formats, :name, unique: true
  end
end
