class CreateDerivations < ActiveRecord::Migration
  def change
    create_table :derivations do |t|
      t.sortable
      t.string :publishable_type, null: false
      t.belongs_to :source_publishable, null: false
      t.belongs_to :derived_publishable, null: false
      t.datetime :hidden_at

      t.timestamps
    end

    add_index :derivations, [:derived_publishable_id, :publishable_type, :position], unique: true, name: "index_derivations_on_d_p_id_and_p_type_and_position"
    add_index :derivations, [:source_publishable_id, :derived_publishable_id, :publishable_type], unique: true, name: "index_derivations_on_s_p_id_and_d_p_id_and_p_type"
  end
end
