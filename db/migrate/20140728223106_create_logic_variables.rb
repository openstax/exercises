class CreateLogicVariables < ActiveRecord::Migration[4.2]
  def change
    create_table :logic_variables do |t|
      t.references :logic, null: false
      t.string :variable, null: false

      t.timestamps null: false
    end

    add_index :logic_variables, [:logic_id, :variable], unique: true
  end
end
