class CreateDeputizations < ActiveRecord::Migration
  def change
    create_table :deputizations do |t|
      t.integer :deputizer_id
      t.integer :deputy_id

      t.timestamps
    end

    add_index :deputizations, [:deputizer_id, :deputy_id], :unique => true
    add_index :deputizations, :deputy_id
  end
end
