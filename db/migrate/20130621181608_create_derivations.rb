class CreateDerivations < ActiveRecord::Migration
  def change
    create_table :derivations do |t|
      t.integer :position, :null => false
      t.string :publishable_type, :null => false
      t.integer :source_publishable_id, :null => false
      t.integer :derived_publishable_id, :null => false

      t.timestamps
    end

    add_index :derivations, [:publishable_type, :source_publishable_id, :derived_publishable_id], :unique => true
    add_index :derivations, [:publishable_type, :derived_publishable_id, :position], :unique => true
  end
end
