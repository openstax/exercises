class CreateCommunitySolutions < ActiveRecord::Migration[4.2]
  def change
    create_table :community_solutions do |t|
      t.references :question, null: false
      t.string :title
      t.text :solution_type, null: false
      t.text :content, null: false

      t.timestamps null: false
    end

    add_index :community_solutions, :question_id
    add_index :community_solutions, :title
    add_index :community_solutions, :solution_type
  end
end
