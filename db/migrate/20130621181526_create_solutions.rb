class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.text :content
      t.text :content_html
      t.text :summary
      t.integer :question_id

      t.timestamps
    end
  end
end
