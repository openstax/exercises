class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.references :account, null: false
      t.datetime :registered_at
      t.datetime :disabled_at

      t.timestamps
    end

    add_index :users, :account_id, unique: true
    add_index :users, :registered_at
    add_index :users, :disabled_at
  end
end
