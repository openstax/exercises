class RemoveTrustedApplications < ActiveRecord::Migration[5.2]
  def change
    drop_table :trusted_applications
  end
end
