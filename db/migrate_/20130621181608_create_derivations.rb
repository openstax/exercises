class CreateDerivations < ActiveRecord::Migration
  def change
    create_table :derivations do |t|
      t.sortable
      t.string :publishable_type, null: false
      t.belongs_to :source_publishable, null: false
      t.belongs_to :derived_publishable, null: false

      t.timestamps
    end

    add_index :derivations, [:publishable_type, :derived_publishable_id, :position], unique: true, name: "index_d_on_p_type_and_d_p_id_and_position"
    add_index :derivations, [:publishable_type, :source_publishable_id, :derived_publishable_id], unique: true, name: "index_d_on_p_type_and_s_p_id_and_d_p_id"
  end
end
