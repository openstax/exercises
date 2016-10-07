class AddUuidToPublications < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.execute 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";'

    add_column :publications, :uuid, :uuid

    Publication.unscoped.update_all('uuid = uuid_generate_v4()')

    change_column_null :publications, :uuid, false
    add_index :publications, :uuid, unique: true
  end
end
