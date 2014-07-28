class CreateFormatSolutions < ActiveRecord::Migration
  def change
    create_table :format_solutions do |t|
      t.references :format, null: false
      t.references :solution, null: false

      t.timestamps
    end

    add_index :format_solutions, [:format_id, :solution_id], unique: true
    add_index :format_solutions, :solution_id
  end
end
