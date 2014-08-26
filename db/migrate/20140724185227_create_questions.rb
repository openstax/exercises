class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.sortable
      t.references :part, null: false
      t.text :stem, null: false, default: ''

      t.timestamps
    end

    add_sortable_index :questions, :part_id
  end
end
