class CreateDeputies < ActiveRecord::Migration
  def change
    create_table :deputies do |t|
      t.references :deputizer, null: false
      t.references :deputy, polymorphic: true, null: false

      t.timestamps
    end

    add_index :deputies, [:deputy_id, :deputy_type, :deputizer_id], unique: true
    add_index :deputies, :deputizer_id
  end
end
