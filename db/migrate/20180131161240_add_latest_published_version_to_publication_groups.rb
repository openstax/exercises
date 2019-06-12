class AddLatestPublishedVersionToPublicationGroups < ActiveRecord::Migration[4.2]
  def change
    add_column :publication_groups, :latest_version, :integer
    add_column :publication_groups, :latest_published_version, :integer

    change_column_null :publication_groups, :latest_version, false

    add_index :publication_groups, [ :id, :latest_version ]
    add_index :publication_groups, [ :id, :latest_published_version ]
  end
end
