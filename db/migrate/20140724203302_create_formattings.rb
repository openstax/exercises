class CreateFormattings < ActiveRecord::Migration
  def change
    create_table :formattings do |t|
      t.references :formattable, polymorphic: true, null: false
      t.string :format, null: false

      t.timestamps
    end

    add_index :formattings, [:formattable_id, :formattable_type, :format],
              unique: true, name: 'index_formattings_on_f_id_and_f_type_and_format'
    add_index :formattings, :format
  end
end
