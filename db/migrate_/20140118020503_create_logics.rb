class CreateLogics < ActiveRecord::Migration
  def change
    create_table :logics do |t|
      t.text :code
      t.string :variables
      t.string :logicable_type
      t.integer :logicable_id

      t.timestamps
    end

    add_index "logics", ["logicable_id", "logicable_type"], :name => "index_logics_on_logicable_id_and_logicable_type", :unique => true
  end
end
