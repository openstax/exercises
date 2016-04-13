class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.string :distractor_literals, array: true, null: false, default: []

      t.timestamps null: false

      t.index :name, unique: true
      t.index :description
    end
  end
end
