class CreateRubrics < ActiveRecord::Migration
  def change
    create_table :rubrics do |t|
      t.publishable
      t.references :gradable, polymorphic: true, null: false
      t.text :human_rubric
      t.text :machine_rubric

      t.timestamps
    end

    add_index :rubrics, [:gradable_id, :gradable_type], unique: true
  end
end
