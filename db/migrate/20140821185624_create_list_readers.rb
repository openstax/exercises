class CreateListReaders < ActiveRecord::Migration
  def change
    create_table :list_readers do |t|
      t.references :reader, polymorphic: true, null: false
      t.references :list, null: false

      t.timestamps null: false
    end

    add_index :list_readers, [:reader_id, :reader_type, :list_id], unique: true
    add_index :list_readers, :list_id
  end
end
