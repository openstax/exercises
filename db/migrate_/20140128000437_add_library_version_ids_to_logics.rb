class AddLibraryVersionIdsToLogics < ActiveRecord::Migration
  def change
    add_column :logics, :library_version_ids, :string
  end
end
