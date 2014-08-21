class CreatePartSupports < ActiveRecord::Migration
  def change
    create_table :part_supports do |t|
      t.sortable
      t.references :supporting_part, null: false
      t.references :supported_part, null: false

      t.timestamps
    end

    add_sortable_index :part_supports, :supported_part_id
    add_index :part_supports, [:supporting_part_id, :supported_part_id], unique: true,
              name: 'index_part_supports_on_s_p_id_and_s_p_id'
  end
end
