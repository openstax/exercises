class CreateLibraries < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.references :owner
      t.string :name, null: false
      t.string :language, null: false, default: 'javascript'
      t.boolean :always_required, null: false, default: false
      t.text :summary

      t.timestamps
    end

    add_index :libraries, [:owner_id, :name], unique: true
    add_index :libraries, [:language, :always_required]
  end
end
