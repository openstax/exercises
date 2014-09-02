class CreatePartSupports < ActiveRecord::Migration
  def change
    create_table :part_supports do |t|
      t.references :supporting_part, null: false
      t.references :supported_part, null: false

      t.timestamps
    end

    add_index :part_supports, [:supported_part_id, :supporting_part_id], unique: true,
              name: 'index_part_supports_on_supported_p_id_and_supporting_p_id'
    add_index :part_supports, :supporting_part_id
  end
end
