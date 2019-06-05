class CreateDeputizations < ActiveRecord::Migration[4.2]
  def change
    create_table :deputizations do |t|
      t.references :deputizer, null: false
      t.references :deputy, polymorphic: true, null: false

      t.timestamps null: false
    end

    add_index :deputizations, [:deputy_id, :deputy_type, :deputizer_id],
              unique: true,
              name: 'index_deputizations_on_d_id_and_d_type_and_d_id'
    add_index :deputizations, :deputizer_id
  end
end
