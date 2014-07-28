class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.sortable
      t.references :part, null: false
      t.string :default_format, null: false
      t.boolean :can_select_multiple, null: false, default: false

      t.timestamps
    end

    add_sortable_index :questions, :part_id
  end
end
