class ChangeLogics < ActiveRecord::Migration
  def change
    remove_index :logics, name: "index_logics_on_logicable_id_and_logicable_type"
    remove_column :logics, :logicable_type
    remove_column :logics, :logicable_id
  end
end
