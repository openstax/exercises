class CreateSolutionFormats < ActiveRecord::Migration
  def change
    create_table :solution_formats do |t|
      t.references :solution, null: false
      t.references :format, null: false

      t.timestamps
    end

    add_index :solution_formats, [:solution_id, :format_id], unique: true
    add_index :solution_formats, :format_id
  end
end
