class CreateTrustedApplications < ActiveRecord::Migration
  def change
    create_table :trusted_applications do |t|
      t.references :application, null: false

      t.timestamps
    end

    add_index :trusted_applications, :application_id, unique: true
  end
end
