class CreateFormattings < ActiveRecord::Migration
  def change
    create_table :formattings do |t|
      t.references :formattable, polymorphic: true, null: false
      t.references :format, null: false

      t.timestamps
    end

    add_index :formattings, [:formattable_id, :formattable_type, :format_id],
              unique: true, name: 'index_formattings_on_f_id_and_f_type_and_f_id'
    add_index :formattings, :format_id
  end
end
