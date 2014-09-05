class CreateLibraries < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.references :language, null: false
      t.string :name
      t.text :description
      t.text :code, null: false

      t.timestamps
    end

    add_index :libraries, :language_id
    add_index :libraries, :name
  end
end
