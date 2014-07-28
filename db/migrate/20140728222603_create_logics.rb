class CreateLogics < ActiveRecord::Migration
  def change
    create_table :logics do |t|
      t.text :code, null: false
      t.text :variables, null: false

      t.timestamps
    end
  end
end
