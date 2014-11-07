class CreateStylings < ActiveRecord::Migration
  def change
    create_table :stylings do |t|
      t.references :stylable, polymorphic: true, null: false
      t.string :style, null: false

      t.timestamps null: false
    end

    add_index :stylings, [:stylable_id, :stylable_type, :style], unique: true
    add_index :stylings, :style
  end
end
