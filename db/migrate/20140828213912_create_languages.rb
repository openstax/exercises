class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name, null: false
      t.string :title, null: false
      t.text :description

      t.timestamps
    end

    add_index :languages, :name, unique: true
    add_index :languages, :title, unique: true
  end
end
