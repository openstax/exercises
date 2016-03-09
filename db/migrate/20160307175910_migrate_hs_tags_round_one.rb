class MigrateHsTagsRoundOne < ActiveRecord::Migration
  def up
    require 'migrate_hs_tags_one'
    MigrateHsTagsOne.call
  end

  def down
    raise ActiveRecord::IrreversibleMigration, 'Just restore the backup...'
  end
end
