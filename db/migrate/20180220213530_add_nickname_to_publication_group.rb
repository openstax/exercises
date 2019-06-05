class AddNicknameToPublicationGroup < ActiveRecord::Migration[4.2]
  def change
    add_column :publication_groups, :nickname, :string
    add_index :publication_groups, :nickname, unique: true
  end
end
