class CreateListPublicationGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :list_publication_groups do |t|
      t.sortable
      t.references :list, null: false, foreign_key: true
      t.references :publication_group, null: false, foreign_key: true

      t.timestamps null: false

      t.index [:publication_group_id, :list_id],
              unique: true, name: 'index_list_publication_groups_on_p_g_id_and_l_id'
    end

    add_sortable_index :list_publication_groups, scope: :list_id
  end
end
