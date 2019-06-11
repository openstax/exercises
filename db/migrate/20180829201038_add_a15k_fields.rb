class AddA15kFields < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :a15k_identifier, :string, index: true
    add_column :exercises, :a15k_version, :integer
    add_column :exercises, :release_to_a15k, :boolean, index: true
  end
end
