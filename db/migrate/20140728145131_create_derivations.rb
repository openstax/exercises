class CreateDerivations < ActiveRecord::Migration[4.2]
  def change
    create_table :derivations do |t|
      t.sortable
      t.belongs_to :derived_publication, null: false
      t.belongs_to :source_publication
      t.text :custom_attribution
      t.datetime :hidden_at

      t.timestamps null: false
    end

    add_sortable_index :derivations, scope: :derived_publication_id
    add_index :derivations, [:source_publication_id, :derived_publication_id],
              unique: true,
              name: "index_derivations_on_source_p_id_and_derived_p_id"
    add_index :derivations, [:derived_publication_id, :hidden_at]
  end
end
