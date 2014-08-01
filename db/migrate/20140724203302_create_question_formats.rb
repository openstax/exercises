class CreateQuestionFormats < ActiveRecord::Migration
  def change
    create_table :question_formats do |t|
      t.references :question, null: false
      t.references :format, null: false

      t.timestamps
    end

    add_index :question_formats, [:question_id, :format_id], unique: true
    add_index :question_formats, :format_id
  end
end
