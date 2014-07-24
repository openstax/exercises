class CreateStems < ActiveRecord::Migration
  def change
    create_table :stems do |t|
      t.references :question, null: false
      t.string :format, null: false

      t.timestamps
    end

    add_sortable_index :stems, [:question_id, :format], unique: true
  end
end
