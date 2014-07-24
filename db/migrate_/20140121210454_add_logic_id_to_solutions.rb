class AddLogicIdToSolutions < ActiveRecord::Migration
  def change
    add_column :solutions, :logic_id, :integer
    add_index :solutions, :logic_id, unique: true
  end
end
