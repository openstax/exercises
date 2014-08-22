class CreateDerivations < ActiveRecord::Migration
  def change
    create_table :derivations do |t|
      t.sortable
      t.belongs_to :source_publication, null: false
      t.belongs_to :derived_publication, null: false
      t.datetime :hidden_at

      t.timestamps
    end

    add_index :derivations, [:derived_publication_id, :position], unique: true
    add_index :derivations, [:source_publication_id, :derived_publication_id],
              unique: true, name: "index_derivations_on_source_p_id_and_derived_p_id"
  end
end
