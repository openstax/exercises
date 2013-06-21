class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.integer :number
      t.integer :version
      t.text :content
      t.text :content_html
      t.integer :license_id
      t.integer :locked_by
      t.datetime :locked_at
      t.boolean :changes_solution
      t.datetime :embargoed_until
      t.boolean :only_embargo_solutions
      t.decimal :suggested_credit

      t.timestamps
    end
  end
end
