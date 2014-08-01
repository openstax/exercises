class CreateGradingAlgorithms < ActiveRecord::Migration
  def change
    create_table :grading_algorithms do |t|
      t.string :name, null: false
      t.string :routine_name, null: false
      t.text :description, null: false

      t.timestamps
    end

    add_index :grading_algorithms, :name, unique: true
    add_index :grading_algorithms, :routine_name, unique: true
  end
end
