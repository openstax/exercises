class FixLatestVersionInPublicationGroups < ActiveRecord::Migration[6.1]
  # Each pass runs in its own transaction, so the rows it locks are released when it commits
  disable_ddl_transaction!

  # Publishing an older draft used to lower latest_version below versions that already exist,
  # and deleting the newest draft used to leave latest_version pointing at the deleted version.
  # Groups with no versions left are skipped because the next version created sets latest_version.
  STALE_GROUPS_SQL = <<~SQL
    FROM publication_groups
    WHERE publication_groups.latest_version <> (
      SELECT MAX(publications.version)
      FROM publications
      WHERE publications.publication_group_id = publication_groups.id
    )
  SQL

  def up
    # Groups skipped because they were locked are fixed in a later pass
    while select_value("SELECT EXISTS (SELECT 1 #{STALE_GROUPS_SQL})")
      transaction do
        # Lock the stale groups, skipping any that a request is creating or deleting a version in.
        # Waiting for those could deadlock with the request, so they are fixed in a later pass instead.
        ids = select_values("SELECT publication_groups.id #{STALE_GROUPS_SQL} FOR UPDATE SKIP LOCKED")
        next if ids.empty?

        # The highest versions are read in a new statement, after the locks are taken, so they include
        # any version committed before then. No version can be created in a locked group until this
        # transaction commits, because creating a version locks its group first.
        execute <<~SQL
          UPDATE publication_groups
          SET latest_version = COALESCE((
            SELECT MAX(publications.version)
            FROM publications
            WHERE publications.publication_group_id = publication_groups.id
          ), publication_groups.latest_version)
          WHERE publication_groups.id IN (#{ids.join(', ')})
        SQL
      end

      sleep 0.1
    end
  end

  def down
  end
end
