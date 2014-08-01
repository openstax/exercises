class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.sortable
      t.references :question, null: false
      t.text :content, null: false

      t.timestamps
    end

    add_sortable_index :items, :question_id
  end
end
