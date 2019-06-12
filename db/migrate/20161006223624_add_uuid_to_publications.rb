class AddUuidToPublications < ActiveRecord::Migration[4.2]
  def change
    add_column :publications, :uuid, :uuid

    change_column_null :publications, :uuid, false
    add_index :publications, :uuid, unique: true
  end
end
