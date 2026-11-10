class FixLatestVersionInPublicationGroups < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        # Publishing an older draft used to lower latest_version below versions that already exist,
        # and deleting the newest draft used to leave latest_version pointing at the deleted version.
        # Set it to the highest version in each group.
        # Locking publications stops versions from being created or deleted until this migration
        # commits, so a version created during the update can't have its latest_version overwritten.
        execute 'LOCK TABLE publications IN SHARE MODE'
        execute <<~SQL
          UPDATE publication_groups
          SET latest_version = highest.version
          FROM (
            SELECT publication_group_id, MAX(version) AS version
            FROM publications
            GROUP BY publication_group_id
          ) AS highest
          WHERE highest.publication_group_id = publication_groups.id
            AND publication_groups.latest_version <> highest.version
        SQL
      end
    end
  end
end
