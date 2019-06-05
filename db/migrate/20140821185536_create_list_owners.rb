class CreateListOwners < ActiveRecord::Migration[4.2]
  def change
    create_table :list_owners do |t|
      t.references :owner, polymorphic: true, null: false
      t.references :list, null: false

      t.timestamps null: false
    end

    add_index :list_owners, [:owner_id, :owner_type, :list_id], unique: true
    add_index :list_owners, :list_id
  end
end
