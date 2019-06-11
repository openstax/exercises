class AddLatestPublishedVersionToPublicationGroups < ActiveRecord::Migration[4.2]
  def change
    add_column :publication_groups, :latest_version, :integer
    add_column :publication_groups, :latest_published_version, :integer

    reversible do |dir|
      dir.up do
        PublicationGroup.update_all(
          <<-UPDATE_SQL.strip_heredoc
            "latest_version" = (
              SELECT MAX("publications"."version")
              FROM "publications"
              WHERE "publications"."publication_group_id" = "publication_groups"."id"
            ),
            "latest_published_version" = (
              SELECT MAX("publications"."version")
              FROM "publications"
              WHERE "publications"."publication_group_id" = "publication_groups"."id"
                AND "publications"."published_at" IS NOT NULL
            )
          UPDATE_SQL
        )
      end
    end

    change_column_null :publication_groups, :latest_version, false

    add_index :publication_groups, [ :id, :latest_version ]
    add_index :publication_groups, [ :id, :latest_published_version ]
  end
end
