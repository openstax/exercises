class ModifyQuestion < ActiveRecord::Migration
  def up
    remove_column :questions, :credit
    remove_column :questions, :exercise_id
    remove_index :questions, [:exercise_id, :position]

    add_column :questions, :part_id, :integer
    add_index :questions, :part_id

    add_column :questions, :is_default, :boolean, default: false, null: false
    add_index :questions, :is_default

    add_column :questions, :format_type, :string, null: false, default: ''
    add_column :questions, :format_id, :integer, null: false, default: ''

    add_index :questions, [:format_id, :format_type], unique: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
