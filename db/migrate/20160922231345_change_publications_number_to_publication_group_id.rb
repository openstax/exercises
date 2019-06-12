class ChangePublicationsNumberToPublicationGroupId < ActiveRecord::Migration[4.2]
  def up
    add_column :publications, :publication_group_id, :integer

    change_column_null :publications, :publication_group_id, false
    add_index :publications, :publication_group_id
    remove_column :publications, :number
  end

  def down
  end
end
