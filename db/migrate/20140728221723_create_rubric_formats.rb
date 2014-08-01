class CreateRubricFormats < ActiveRecord::Migration
  def change
    create_table :rubric_formats do |t|
      t.references :rubric, null: false
      t.references :format, null: false

      t.timestamps
    end

    add_index :rubric_formats, [:rubric_id, :format_id], unique: true
    add_index :rubric_formats, :format_id
  end
end
