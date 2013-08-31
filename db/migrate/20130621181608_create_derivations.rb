class CreateDerivations < ActiveRecord::Migration
  def change
    create_table :derivations do |t|
      t.integer :position, :null => false
      t.string :publishable_type, :null => false
      t.integer :source_publishable_id, :null => false
      t.integer :derived_publishable_id, :null => false

      t.timestamps
    end

    add_index :derivations, [:publishable_type, :source_publishable_id, :derived_publishable_id], :unique => true, :name => "index_d_on_p_type_and_s_p_id_and_d_p_id"
    add_index :derivations, [:publishable_type, :derived_publishable_id, :position], :unique => true, :name => "index_d_on_p_type_and_d_p_id_and_position"
  end
end
