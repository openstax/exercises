class CreateLogicOutputs < ActiveRecord::Migration
  def change
    create_table :logic_outputs do |t|
      t.integer :seed
      t.text :values
      t.integer :logic_id

      t.timestamps
    end

    add_index :logic_outputs, :logic_id
  end
end
