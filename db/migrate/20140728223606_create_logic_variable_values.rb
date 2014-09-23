class CreateLogicVariableValues < ActiveRecord::Migration
  def change
    create_table :logic_variable_values do |t|
      t.references :logic_variable, null: false
      t.integer :seed, null: false
      t.text :value, null: false

      t.timestamps
    end

    add_index :logic_variable_values, [:logic_variable_id, :seed], unique: true
    add_index :logic_variable_values, :seed
  end
end
