class AddPublicationContractNameToLicenses < ActiveRecord::Migration
  def change
    add_column :licenses, :publishing_contract_name, :string
    remove_column :licenses, :partial_filename
  end
end
