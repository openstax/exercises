class CreateHints < ActiveRecord::Migration[4.2]
  def change
    create_table :hints do |t|
      t.sortable
      t.references :question, null: false
      t.text :content, null: false

      t.timestamps null: false
    end

    add_sortable_index :hints, scope: :question_id
  end
end
