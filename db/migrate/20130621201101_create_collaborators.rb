class CreateCollaborators < ActiveRecord::Migration
  def change
    create_table :collaborators do |t|
      t.integer :user_id
      t.integer :collaborable_id
      t.string :collaborable_type
      t.integer :number
      t.boolean :is_author
      t.boolean :is_copyright_holder

      t.timestamps
    end

    add_index :collaborators, [:collaborable_type, :collaborable_id, :number], :unique => true, :name => "index_c_on_c_type_and_c_id_and_number"
    add_index :collaborators, [:user_id, :collaborable_type, :collaborable_id], :unique => true, :name => "index_c_on_u_id_and_c_type_and_c_id"
    add_index :collaborators, :is_author
    add_index :collaborators, :is_copyright_holder
  end
end
