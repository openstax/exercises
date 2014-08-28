class CreateLicenseCompatibilities < ActiveRecord::Migration
  def change
    create_table :license_compatibilities do |t|
      t.references :original_license, null: false
      t.references :combined_license, null: false

      t.timestamps
    end

    add_index :license_compatibilities, [:combined_license_id, :original_license_id],
              unique: true, name: 'index_license_compatibilities_on_c_l_id_and_o_l_id'
    add_index :license_compatibilities, :original_license_id
  end
end
