class CreateTrustedApplications < ActiveRecord::Migration[4.2]
  def change
    create_table :trusted_applications do |t|
      t.references :application, null: false

      t.timestamps null: false
    end

    add_index :trusted_applications, :application_id, unique: true
  end
end
