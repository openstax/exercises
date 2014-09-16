class CreateCollaborators < ActiveRecord::Migration
  def change
    create_table :collaborators do |t|
      t.references :publication, null: false
      t.references :user, null: false
      t.boolean :is_author, null: false, default: false
      t.boolean :is_copyright_holder, null: false, default: false

      t.timestamps
    end

    add_index :collaborators, [:publication_id, :user_id], unique: true
    add_index :collaborators, :user_id
  end
end
