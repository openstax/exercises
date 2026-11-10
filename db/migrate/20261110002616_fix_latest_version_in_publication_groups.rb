class FixLatestVersionInPublicationGroups < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        # Publishing an older draft used to lower latest_version below versions that already exist.
        # Raise it to the highest version in each group.
        execute <<~SQL
          UPDATE publication_groups
          SET latest_version = highest.version
          FROM (
            SELECT publication_group_id, MAX(version) AS version
            FROM publications
            GROUP BY publication_group_id
          ) AS highest
          WHERE highest.publication_group_id = publication_groups.id
            AND publication_groups.latest_version < highest.version
        SQL
      end
    end
  end
end
