class CreateLogicOutputs < ActiveRecord::Migration
  def change
    create_table :logic_outputs do |t|
      t.references :logic, null: false
      t.integer :seed, null: false
      t.text :values, null: false

      t.timestamps
    end

    add_index :logic_outputs, [:logic_id, :seed], unique: true
  end
end
