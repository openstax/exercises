class AddUuidToPublications < ActiveRecord::Migration[4.2]
  def change
    ActiveRecord::Base.connection.execute 'CREATE EXTENSION IF NOT EXISTS "pgcrypto";'

    add_column :publications, :uuid, :uuid

    Publication.unscoped.update_all('uuid = gen_random_uuid()')

    change_column_null :publications, :uuid, false
    add_index :publications, :uuid, unique: true
  end
end
