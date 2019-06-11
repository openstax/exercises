class CreateAdministrators < ActiveRecord::Migration[4.2]
  def change
    create_table :administrators do |t|
      t.references :user, null: false

      t.timestamps null: false
    end

    add_index :administrators, :user_id, unique: true
  end
end
