class CreateLogicVariableValues < ActiveRecord::Migration[4.2]
  def change
    create_table :logic_variable_values do |t|
      t.references :logic_variable, null: false
      t.integer :seed, null: false
      t.text :value, null: false

      t.timestamps null: false
    end

    add_index :logic_variable_values, [:logic_variable_id, :seed], unique: true
  end
end
