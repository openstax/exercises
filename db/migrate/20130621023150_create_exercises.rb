class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.text :content
      t.text :content_html
      t.integer :number
      t.integer :version
      t.datetime :published_at
      t.integer :source_exercise_id
      t.decimal :suggested_credit
      t.integer :license_id
      t.datetime :embargoed_until
      t.boolean :only_embargo_solutions
      t.integer :locked_by
      t.datetime :locked_at

      t.timestamps
    end

    add_index :exercises, [:number, :version]
    add_index :exercises, :published_at
    add_index :exercises, :source_exercise_id
    add_index :exercises, :license_id
  end
end
