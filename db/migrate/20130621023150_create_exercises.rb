class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.text :content, :null => false, :default => ''
      t.text :content_cache, :null => false, :default => ''
      t.integer :number, :null => false
      t.integer :version, :null => false
      t.datetime :published_at
      t.integer :license_id
      t.integer :source_exercise_id
      t.datetime :embargoed_until
      t.boolean :only_embargo_solutions, :null => false, :default => false
      t.decimal :credit
      t.integer :locked_by
      t.datetime :locked_at

      t.timestamps
    end

    add_index :exercises, [:number, :version], :unique => true
    add_index :exercises, :published_at
    add_index :exercises, :source_exercise_id
    add_index :exercises, :license_id
  end
end
