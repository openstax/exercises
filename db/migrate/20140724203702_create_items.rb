class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :question, null: false
      t.string :reference
      t.text :content

      t.timestamps null: false
    end

    add_index :items, [:question_id, :reference], unique: true
  end
end
