class CreatePublicationGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :publication_groups do |t|
      t.string  :publishable_type, null: false, index: true
      t.integer :number,           null: false
      t.uuid    :uuid,             null: false, index: { unique: true }

      t.timestamps null: false

      t.index [:number, :publishable_type], unique: true
    end
  end
end
