class CreateSorts < ActiveRecord::Migration
  def change
    create_table :sorts do |t|
      t.references :domain, polymorphic: true
      t.references :sortable, polymorphic: true, null: false
      t.integer :position, null: false

      t.timestamps null: false
    end

    add_index :sorts, [:sortable_id, :sortable_type, :domain_id, :domain_type],
      unique: true, name: 'index_sorts_on_s_id_and_s_type_and_d_id_and_d_type'
    add_index :sorts, [:domain_id, :domain_type, :sortable_type, :position],
      unique: true, name: 'index_sorts_on_d_id_and_d_type_and_s_type_and_position'
    if supports_partial_index?
      add_index :sorts, [:sortable_id, :sortable_type],
                unique: true, where: 'domain_id IS NULL'
      add_index :sorts, [:sortable_type, :position],
                unique: true, where: 'domain_id IS NULL'
    end
  end
end
