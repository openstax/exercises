class CreateSorts < ActiveRecord::Migration
  def change
    create_table :sorts do |t|
      t.references :domain, polymorphic: true, null: false
      t.references :sortable, polymorphic: true, null: false
      t.integer :position, null: false

      t.timestamps
    end

    add_index :sorts, [:domain_id, :domain_type, :sortable_type, :position],
      unique: true, name: 'index_sorts_on_d_id_and_d_type_and_s_type_and_position'
    add_index :sorts, [:sortable_id, :sortable_type, :domain_id, :domain_type],
      unique: true, name: 'index_sorts_on_s_id_and_s_type_and_d_id_and_d_type'
  end
end
