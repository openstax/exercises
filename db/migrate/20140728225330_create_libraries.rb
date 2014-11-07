class CreateLibraries < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.string :name
      t.string :language, null: false
      t.text :description
      t.text :code, null: false

      t.timestamps null: false
    end

    add_index :libraries, :name
    add_index :libraries, :language
  end
end
