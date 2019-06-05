class CreateStems < ActiveRecord::Migration[4.2]
  def change
    create_table :stems do |t|
      t.references :question, null: false
      t.text :content, null: false

      t.timestamps null: false
    end

    add_index :stems, :question_id
  end
end
