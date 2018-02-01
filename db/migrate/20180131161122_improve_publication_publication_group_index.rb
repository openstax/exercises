class ImprovePublicationPublicationGroupIndex < ActiveRecord::Migration
  def change
    remove_index :publications, :publication_group_id

    add_index :publications, [ :publication_group_id, :version ]
  end
end
