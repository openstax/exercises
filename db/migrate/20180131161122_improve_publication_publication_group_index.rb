class ImprovePublicationPublicationGroupIndex < ActiveRecord::Migration[4.2]
  def change
    remove_index :publications, :publication_group_id

    add_index :publications, [ :publication_group_id, :version ]
  end
end
