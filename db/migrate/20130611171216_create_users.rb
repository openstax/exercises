class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.boolean :is_registered
      t.timestamps
    end
  end
end
